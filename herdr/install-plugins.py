#!/usr/bin/env python3
"""Install declared Herdr plugins without replacing unrelated installations."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib


class SetupError(Exception):
    pass


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def read_json(path):
    return json.loads(path.read_text(), object_pairs_hook=unique_object,
                      parse_constant=lambda value: (_ for _ in ()).throw(ValueError(value)))


def relative_path(value):
    if not isinstance(value, str) or not value or Path(value).is_absolute() or any(p in (".", "..") for p in value.split("/")):
        raise SetupError(f"invalid relative path: {value!r}")
    return value


def load_declarations(path):
    with path.open("rb") as stream:
        data = tomllib.load(stream)
    plugins = data.get("plugin")
    if not isinstance(plugins, list) or not plugins:
        raise SetupError("plugin declarations must be a nonempty array")
    ids = set()
    for plugin in plugins:
        if not isinstance(plugin, dict) or set(plugin) != {"id", "source"}:
            raise SetupError("invalid plugin declaration")
        ident = plugin.get("id")
        if not isinstance(ident, str) or not ident or ident in ids:
            raise SetupError("missing or duplicate declared plugin id")
        ids.add(ident)
        source = plugin.get("source")
        if not isinstance(source, str) or len(source.split("/")) < 2:
            raise SetupError(f"invalid source for {ident}")
        relative_path(source)
    return plugins


def xdg_dir(name, default):
    value = os.environ.get(name)
    if value == "":
        raise SetupError(f"{name} must not be empty")
    return Path(value) if value is not None else Path.home() / default


def registry_entries(registry, herdr):
    config = registry.parent
    if config.exists() or config.is_symlink():
        if not config.is_dir() or not os.access(config, os.R_OK | os.X_OK):
            raise SetupError(f"cannot access Herdr config directory: {config}")
    if registry.exists() or registry.is_symlink():
        if registry.is_symlink() or not registry.is_file():
            raise SetupError(f"cannot read plugin registry: {registry}")
        raw = read_json(registry)
    else:
        raw = []
    if not isinstance(raw, list):
        raise SetupError("invalid plugin registry")
    ids = set()
    for entry in raw:
        if not isinstance(entry, dict) or any(not isinstance(entry.get(k), str) for k in ("plugin_id", "name", "version", "manifest_path", "plugin_root")) or not isinstance(entry.get("enabled"), bool) or (entry.get("source") is not None and not isinstance(entry["source"], dict)):
            raise SetupError("invalid plugin registry entry")
        if entry["plugin_id"] in ids:
            raise SetupError("duplicate plugin id in registry")
        ids.add(entry["plugin_id"])
    result = subprocess.run([herdr, "plugin", "list", "--json"], check=True, capture_output=True, text=True)
    response = json.loads(result.stdout, object_pairs_hook=unique_object,
                          parse_constant=lambda value: (_ for _ in ()).throw(ValueError(value)))
    if not isinstance(response, dict) or not isinstance(response.get("result"), dict):
        raise SetupError("invalid plugin list response")
    data = response["result"]
    live = data.get("plugins")
    if data.get("type") != "plugin_list" or not isinstance(live, list) or len(live) != len(raw):
        raise SetupError("invalid or inconsistent plugin list response")
    live_by_id = {}
    for entry in live:
        if (not isinstance(entry, dict) or not isinstance(entry.get("plugin_id"), str)
                or entry["plugin_id"] in live_by_id
                or not all(isinstance(entry.get(k), str) for k in ("plugin_root", "manifest_path"))
                or not isinstance(entry.get("enabled"), bool)
                or (entry.get("source") is not None and not isinstance(entry["source"], dict))):
            raise SetupError("invalid or duplicate plugin list entry")
        live_by_id[entry["plugin_id"]] = entry
    for entry in raw:
        other = live_by_id.get(entry["plugin_id"])
        if other is None or any(json.dumps(entry.get(k), sort_keys=True) != json.dumps(other.get(k), sort_keys=True) for k in ("plugin_root", "manifest_path", "enabled", "source")):
            raise SetupError("registry/list mismatch")
    return live_by_id


def source_subdir(plugin, entry):
    if entry is None:
        return None
    source = entry.get("source")
    parts = plugin["source"].split("/")
    target = "/".join(parts[2:])
    if not isinstance(source, dict) or source.get("kind") != "github" or not isinstance(source.get("owner"), str) or source["owner"].lower() != parts[0].lower() or not isinstance(source.get("repo"), str) or source["repo"].lower() != parts[1].lower():
        raise SetupError(f"plugin {plugin['id']} belongs to another source")
    subdir = source.get("subdir")
    if subdir is None:
        subdir = ""
    if not isinstance(subdir, str):
        raise SetupError(f"invalid source for {plugin['id']}")
    allowed = [target, "lite"] if plugin["id"] == "annotate" else [target]
    if subdir not in allowed:
        raise SetupError(f"plugin {plugin['id']} belongs to another source")
    return subdir


def healthy(plugin, entry):
    if entry is None or source_subdir(plugin, entry) != "/".join(plugin["source"].split("/")[2:]):
        return False
    root = Path(entry["plugin_root"])
    manifest = root / "herdr-plugin.toml"
    if not entry["plugin_root"] or entry["manifest_path"] != str(manifest) or not manifest.is_file():
        return False
    warnings = entry.get("warnings", [])
    if not isinstance(warnings, list) or any(not isinstance(w, str) or w.startswith("manifest unavailable:") for w in warnings):
        return False
    try:
        with manifest.open("rb") as stream:
            parsed = tomllib.load(stream)
        if parsed.get("id") != plugin["id"]:
            return False
        if plugin["id"] == "annotate":
            actions = parsed.get("actions", [])
            builds = parsed.get("build", [])
            if (not isinstance(actions, list) or not any(isinstance(item, dict) and item.get("id") == "open" for item in actions)
                    or not isinstance(builds, list) or not any(isinstance(item, dict) and item.get("command") == ["bash", "scripts/fetch-plannotator-tui.sh"] for item in builds)):
                return False
            for expected, installed in (("herdr-annotate.version", "bin/herdr-annotate.version"),
                                        ("plannotator-tui.version", "bin/plannotator-tui.version")):
                if not (root / expected).is_file() or not (root / installed).is_file():
                    return False
                if "".join((root / expected).read_text().split()) != "".join((root / installed).read_text().split()):
                    return False
            checks = (("bin/herdr-annotate.exe", ["--version"], {}),
                      ("bin/plannotator-tui.exe", ["--version"], {}))
        elif plugin["id"] == "herdr-sidebar":
            checks = (("target/release/herdr-sidebar", ["--event-kind"], {"HERDR_PLUGIN_EVENT_JSON": ""}),)
        else:
            checks = ()
        for path, args, extra_env in checks:
            executable = root / path
            if not executable.is_file() or not os.access(executable, os.X_OK):
                return False
            env = os.environ.copy()
            env.update(extra_env)
            subprocess.run([str(executable), *args], env=env, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True, timeout=30)
    except (OSError, ValueError, subprocess.SubprocessError):
        return False
    return True


def main():
    plugins = load_declarations(Path(__file__).with_name("plugins.toml"))
    config = xdg_dir("XDG_CONFIG_HOME", ".config") / "herdr"
    herdr = os.environ.get("HERDR_BIN") or shutil.which("herdr")
    if not herdr or not os.access(herdr, os.X_OK):
        raise SetupError("Herdr executable is required")
    os.environ["PATH"] = str(Path(herdr).resolve().parent) + os.pathsep + os.environ.get("PATH", "")
    registry = config / "plugins.json"
    entries = registry_entries(registry, herdr)
    for plugin in plugins:
        source_subdir(plugin, entries.get(plugin["id"]))
    for plugin in plugins:
        entries = registry_entries(registry, herdr)
        entry = entries.get(plugin["id"])
        source_subdir(plugin, entry)
        if healthy(plugin, entry):
            print(f"{plugin['id']} already installed" + (" (disabled)" if not entry["enabled"] else ""))
            continue
        was_disabled = entry is not None and not entry["enabled"]
        print(f"installing {plugin['source']}")
        subprocess.run([herdr, "plugin", "install", "--yes", plugin["source"]], check=True)
        entries = registry_entries(registry, herdr)
        entry = entries.get(plugin["id"])
        source_subdir(plugin, entry)
        if was_disabled and entry is not None and entry["enabled"]:
            subprocess.run([herdr, "plugin", "disable", plugin["id"]], check=True)
            entry = registry_entries(registry, herdr).get(plugin["id"])
            if entry is None or entry["enabled"]:
                raise SetupError(f"could not preserve disabled state for {plugin['id']}")
        if not healthy(plugin, entry):
            raise SetupError(f"{plugin['id']} installation is incomplete; resolve the error and rerun")
    if sys.platform.startswith("linux") and not any(shutil.which(x) for x in ("wl-copy", "xclip", "xsel")):
        print("Annotate clipboard support needs wl-clipboard, xclip, or xsel")


if __name__ == "__main__":
    try:
        main()
    except (SetupError, OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print(f"Herdr plugin setup failed: {error}", file=sys.stderr)
        sys.exit(1)

"""Isolated plugin installer regression tests, with no Herdr server or installs."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest import mock

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("installer", HERE / "install-plugins.py")
installer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(installer)


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.config = self.root / "config" / "herdr"
        self.config.mkdir(parents=True)
        self.registry = self.config / "plugins.json"
        self.state_root = self.root / "state"
        self.state = self.state_root / "herdr" / "plugins" / "herdr-sidebar" / "state.json"
        self.environ = mock.patch.dict(os.environ, {"HOME": str(self.root), "XDG_CONFIG_HOME": str(self.config.parent), "XDG_STATE_HOME": str(self.state_root), "HERDR_BIN": "/bin/true"})
        self.environ.start()
        self.addCleanup(self.environ.stop)
        self.installs = []
        self.partial = False
        self.list_override = None
        self.install_failure = False
        self.reenable_on_install = False
        self.runtime_calls = []
        self.fail_runtime = None
        self.plugins = installer.load_declarations(HERE / "plugins.toml")
        self.run_patch = mock.patch.object(installer.subprocess, "run", side_effect=self.run_command)
        self.run_patch.start()
        self.addCleanup(self.run_patch.stop)

    def entries(self):
        return json.loads(self.registry.read_text()) if self.registry.exists() else []

    def save(self, entries):
        self.registry.write_text(json.dumps(entries))

    def run_command(self, args, **kwargs):
        if args[1:3] == ["plugin", "list"]:
            output = self.list_override if self.list_override is not None else {"result": {"type": "plugin_list", "plugins": self.entries()}}
            return subprocess.CompletedProcess(args, 0, json.dumps(output), "")
        if args[1:4] == ["plugin", "install", "--yes"]:
            source = args[4]
            self.installs.append(source)
            if self.install_failure:
                raise subprocess.CalledProcessError(1, args)
            ident = {"plannotator/herdr-annotate": "annotate",
                     "alexarthurs/herdr-sidebar/plugins/herdr-sidebar": "herdr-sidebar"}.get(source, source.rsplit("/", 1)[-1])
            root = self.root / ident
            root.mkdir(exist_ok=True)
            manifest = root / "herdr-plugin.toml"
            manifest.write_text('id = "' + ident + '"\n' + ('[[actions]]\nid = "open"\n[[build]]\ncommand = ["bash", "scripts/fetch-plannotator-tui.sh"]\n' if ident == "annotate" else ""))
            paths = (["bin/herdr-annotate.exe", "bin/plannotator-tui.exe"] if ident == "annotate"
                     else ["target/release/herdr-sidebar"] if ident == "herdr-sidebar" else [])
            for path in paths:
                binary = root / path
                binary.parent.mkdir(parents=True, exist_ok=True)
                binary.write_text("executable")
                binary.chmod(0o755)
            if ident == "annotate":
                for name in ("herdr-annotate", "plannotator-tui"):
                    (root / (name + ".version")).write_text("1.0\n")
                    (root / "bin" / (name + ".version")).write_text("1.0\n")
                if self.partial:
                    (root / paths[1]).unlink()
            entries = self.entries()
            old = next((x for x in entries if x["plugin_id"] == ident), None)
            parts = source.split("/")
            item = {"plugin_id": ident, "name": ident, "version": "1", "manifest_path": str(manifest), "plugin_root": str(root), "enabled": (old["enabled"] if old and not self.reenable_on_install else True), "source": {"kind": "github", "owner": parts[0], "repo": parts[1], "subdir": "/".join(parts[2:])}}
            self.save([x for x in entries if x["plugin_id"] != ident] + [item])
            return subprocess.CompletedProcess(args, 0)
        if args[1:3] == ["plugin", "disable"]:
            entries = self.entries()
            next(e for e in entries if e["plugin_id"] == args[3])["enabled"] = False
            self.save(entries)
            return subprocess.CompletedProcess(args, 0)
        self.runtime_calls.append((args, kwargs.get("env", {})))
        if self.fail_runtime and args[0].endswith(self.fail_runtime):
            raise subprocess.CalledProcessError(1, args)
        return subprocess.CompletedProcess(args, 0)

    def setup_plugins(self):
        installer.main()

    def test_install_skip_and_runtime_invocations(self):
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins))
        self.assertFalse(self.state.exists())
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins))
        self.assertFalse(self.state.exists())
        self.assertTrue(any(args[0].endswith("herdr-annotate.exe") and args[1:] == ["--version"] for args, _ in self.runtime_calls))
        self.assertTrue(any(args[0].endswith("plannotator-tui.exe") and args[1:] == ["--version"] for args, _ in self.runtime_calls))
        self.assertTrue(any(args[0].endswith("herdr-sidebar") and args[1:] == ["--event-kind"] and env["HERDR_PLUGIN_EVENT_JSON"] == "" for args, env in self.runtime_calls))

    def test_minimal_manifest_and_generic_plugin(self):
        declarations = self.plugins
        self.assertEqual([plugin["id"] for plugin in declarations],
                         ["annotate", "herdr-sidebar", "herdr-navigator"])
        self.assertTrue(all(set(plugin) == {"id", "source"} for plugin in declarations))
        with mock.patch.object(installer, "load_declarations", return_value=declarations + [
                {"id": "generic", "source": "example/generic"}]):
            self.setup_plugins()
        self.assertEqual(len(self.installs), len(declarations) + 1)
        generic = next(item for item in self.entries() if item["plugin_id"] == "generic")
        self.assertEqual(generic["source"]["owner"], "example")
        self.assertEqual(generic["source"]["repo"], "generic")
        self.assertTrue((self.root / "generic" / "herdr-plugin.toml").is_file())
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(declarations) + 1)

    def test_existing_sidebar_state_is_left_untouched(self):
        self.state.parent.mkdir(parents=True)
        state_bytes = b'{"dock_right": false, "other": {"x": 1}}\n'
        self.state.write_bytes(state_bytes)
        legacy = self.config / "aa-sidebar.json"
        legacy_bytes = b'{"dock_right": true, "legacy": true}\n'
        legacy.write_bytes(legacy_bytes)
        self.setup_plugins()
        self.assertEqual(self.state.read_bytes(), state_bytes)
        self.assertEqual(legacy.read_bytes(), legacy_bytes)
        self.assertFalse(Path(str(self.state) + ".backup").exists())
        self.assertFalse(Path(str(legacy) + ".backup").exists())
        self.assertFalse((self.state.parent / "state.lock").exists())

    def test_sidebar_state_is_not_created_when_absent(self):
        self.assertFalse(self.state.parent.exists())
        self.setup_plugins()
        self.assertFalse(self.state.exists())
        self.assertFalse(self.state.parent.exists())
        self.assertFalse((self.config / "aa-sidebar.json").exists())

    def test_lite_to_full_preserves_disabled_and_healthy_disabled_skips(self):
        self.setup_plugins()
        entries = self.entries()
        for entry in entries:
            entry["enabled"] = False
            if entry["plugin_id"] == "annotate":
                entry["source"]["subdir"] = "lite"
        self.save(entries)
        self.reenable_on_install = True
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 1)
        self.assertTrue(all(not e["enabled"] for e in self.entries()))
        self.assertEqual(next(e for e in self.entries() if e["plugin_id"] == "annotate")["source"]["subdir"], "")
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 1)

    def test_partial_install_and_repair(self):
        self.partial = True
        with self.assertRaisesRegex(installer.SetupError, "incomplete"):
            self.setup_plugins()
        self.assertEqual(len(self.installs), 1)
        self.partial = False
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 1)

    def test_manifest_versions_and_binary_health(self):
        self.setup_plugins()
        root = self.root / "annotate"
        (root / "bin" / "plannotator-tui.version").write_text("other")
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 1)
        (root / "herdr-plugin.toml").write_text('id = "annotate"\n')
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 2)
        (self.root / "herdr-sidebar" / "target/release/herdr-sidebar").chmod(0o644)
        self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 3)
        self.fail_runtime = "herdr-sidebar"
        with self.assertRaisesRegex(installer.SetupError, "incomplete"):
            self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins) + 4)

    def test_conflict_duplicate_and_mismatch_fail_before_install(self):
        self.setup_plugins()
        entries = self.entries()
        entries[1]["source"]["owner"] = "other"
        self.save(entries)
        with self.assertRaises(installer.SetupError):
            self.setup_plugins()
        entries[1]["source"]["owner"] = "alexarthurs"
        self.save(entries + [entries[0]])
        with self.assertRaises(installer.SetupError):
            self.setup_plugins()
        self.save(entries)
        other = json.loads(json.dumps(entries))
        other[0]["enabled"] = False
        self.list_override = {"result": {"type": "plugin_list", "plugins": other}}
        with self.assertRaises(installer.SetupError):
            self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins))

    def test_reject_unapproved_same_repository_transition(self):
        self.setup_plugins()
        entries = self.entries()
        entries[0]["source"]["subdir"] = "windows-full"
        self.save(entries)
        with self.assertRaisesRegex(installer.SetupError, "another source"):
            self.setup_plugins()
        self.assertEqual(len(self.installs), len(self.plugins))

    def test_bad_registry_and_list(self):
        for data in ('garbage', '[]\n[]', '[{}]', '{"invalid":true}', '[{"plugin_id":"x","plugin_id":"y"}]'):
            with self.subTest(data=data):
                self.registry.write_text(data)
                with self.assertRaises((installer.SetupError, ValueError)):
                    self.setup_plugins()
        self.registry.unlink()
        self.list_override = {"error": {}}
        with self.assertRaises(installer.SetupError):
            self.setup_plugins()
        self.assertEqual(self.installs, [])

    def test_empty_xdg_and_install_failure(self):
        with mock.patch.dict(os.environ, {"XDG_CONFIG_HOME": ""}):
            with self.assertRaises(installer.SetupError):
                self.setup_plugins()
        self.install_failure = True
        with self.assertRaises(subprocess.CalledProcessError):
            self.setup_plugins()
        self.assertEqual(len(self.installs), 1)

    def test_real_subprocess_health_checks(self):
        # Build healthy fixtures via the in-memory mock, then run the actual
        # installer in a separate process with real executable probes.
        self.setup_plugins()
        for path in (self.root / "annotate/bin/herdr-annotate.exe", self.root / "annotate/bin/plannotator-tui.exe"):
            path.write_text('#!/bin/sh\n[ "$1" = "--version" ]\n')
        sidebar = self.root / "herdr-sidebar/target/release/herdr-sidebar"
        sidebar.write_text('#!/bin/sh\n[ "$1" = "--event-kind" ] && [ "${HERDR_PLUGIN_EVENT_JSON+x}" = x ] && [ -z "$HERDR_PLUGIN_EVENT_JSON" ]\n')
        fake = self.root / "herdr"
        fake.write_text('#!/bin/sh\n[ "$1 $2 $3" = "plugin list --json" ] || exit 1\nprintf \'{"result":{"type":"plugin_list","plugins":\'\ncat "$XDG_CONFIG_HOME/herdr/plugins.json"\nprintf \'}}\\n\'\n')
        fake.chmod(0o755)
        env = os.environ.copy()
        env["HERDR_BIN"] = str(fake)
        # Use the original subprocess function rather than this fixture's mock.
        self.run_patch.stop()
        try:
            result = subprocess.run([os.sys.executable, str(HERE / "install-plugins.py")], env=env, text=True, capture_output=True)
        finally:
            self.run_patch.start()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("annotate already installed", result.stdout)
        self.assertIn("herdr-sidebar already installed", result.stdout)
        self.assertIn("herdr-navigator already installed", result.stdout)


if __name__ == "__main__":
    unittest.main()

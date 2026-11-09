# Herdr

## Plugins

`plugins.toml` declares each plugin using only its Herdr `id` and GitHub `source`.
Add a plugin by adding another `[[plugin]]` entry with those two fields. The
installer checks that each installed manifest reports its declared ID. It also
checks the built-in requirements for Annotate Full and the Sidebar executable;
Annotate Lite may transition to Full. Other source conflicts are errors.

The installer passes `--yes` to Herdr, which runs upstream build hooks. Review
and trust the declared sources before installing. Healthy installations are
skipped, not updated. Missing or unhealthy installations are reinstalled and
fully checked afterwards, including Annotate's TUI, whose build can fail
without failing the install. Disabled plugins remain disabled. Malformed or
inconsistent registry/list data, duplicate IDs and source conflicts stop setup.
Do not run this alongside another plugin manager or manual plugin management.

Sidebar settings, including docking, are managed by Sidebar/the plugin and
configured through its UI or plugin configuration. This installer does not
enforce right docking or read, write, migrate, or back up Sidebar state. An
empty XDG config variable is rejected.

The shared `python` module owns Python 3.14 through mise. Herdr installs that
module and resolves Python and Herdr from their respective mise configurations.
Jcode uses the same Python for asset setup. Herdr no longer needs jq or Perl.
The standalone jq module is independent.

Run `bash herdr/install.sh` to set up Herdr and its plugins. To run the plugin
installer alone, use `HERDR_BIN=/path/to/herdr python3 herdr/install-plugins.py`
with Python 3.11 or newer. Its isolated tests run with
`python3 -m unittest discover -s herdr -p 'test_install_plugins.py'`.

## Shortcuts

The configured prefix is `Ctrl+Space` or `Ctrl+B`:

- `prefix+a`: capture annotation; `prefix+Shift+a`: copy context.
- `prefix+Ctrl+a`: copy and archive annotations; `prefix+Ctrl+v`: paste an archive; `prefix+Ctrl+s`: send and archive.
- `prefix+m`: manage annotations; `prefix+Ctrl+d`: review documents.
- `prefix+Alt+o`: review the agent's last reply; `prefix+Ctrl+o`: review the newest reply.
- `prefix+f`: toggle the file Sidebar.

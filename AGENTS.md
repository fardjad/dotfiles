# Dotfiles repository guidance

## Scope

This repository contains modular dotfiles for macOS, Ubuntu, WSL, and Codespaces. Keep changes small, focused, and safe to rerun. Preserve unrelated working-tree changes.

## Installation modules

- Each top-level module owns its installation in `<module>/install.sh`.
- `script/setup` automatically discovers `install.sh` files within two directory levels. Do not edit the central setup runner merely to enroll a new top-level module.
- An installer should start with `#!/usr/bin/env bash`, `set -e`, and source the shared helpers:

  ```bash
  source "$(dirname "$0")/../script/bootstrap.bash"
  ```

- Modules needing Homebrew packages should declare them in a module-local `Brewfile` and call `brew_bundle_install`.
- Use shared helpers instead of duplicating behavior: `check_command`, `info`, `fail`, `link_file`, and `remote_bash_install`.
- Make installers idempotent. Check whether a tool or directory already exists before installing it, and emit an informative message when skipping work.
- Remote installers must use `remote_bash_install` so they run with `CI=true` and `SHELL=/bin/false`, avoiding unwanted shell-profile changes.

## Configuration and shell integration

- Store managed configuration in a `*.symlink` directory and link it into its destination with `link_file`.
- Put shell setup in focused `*.zsh` files such as `path.zsh`, `init.zsh`, `aliases.zsh`, or `completion.zsh` when appropriate.
- Do not overwrite user files directly. `link_file` preserves an existing destination as a `.backup` before linking.

## Validation

- Run `bash -n` on every changed shell script.
- For a module installer, verify its `Brewfile`, symlink source paths, and referenced commands or URLs.
- Do not run `script/setup` during routine validation because it installs or upgrades all modules. Run a targeted module installer only when its effects are intended.
- The repository intentionally supports rerunning installers safely.

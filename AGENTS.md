# Dotfiles repository guidance

## Scope

This repository contains modular dotfiles for macOS, Ubuntu, WSL, and Codespaces. Keep changes small, focused, and safe to rerun. Preserve unrelated working-tree changes.

## Installation modules

- Each top-level module owns its installation in `<module>/install.sh`.
- `script/setup` automatically discovers `install.sh` files within two directory levels. Do not edit the central setup runner merely to enroll a new top-level module.
- An installer should start with `#!/usr/bin/env bash`, `set -e`, change to its module directory, then source the shared helpers:

  ```bash
  cd "$(dirname "$0")"
  source "../script/bootstrap.bash"
  ```

- Keep package managers distinct: Brew-managed packages go in the owning module's `Brewfile` and are installed with `brew_bundle_install`; do not duplicate them in mise.
- Prefer mise by default for versioned CLI tools and runtimes. Put each declaration in the owning top-level module's `mise.toml`, `cd` to that module directory at the start of its installer, then call `mise_install_module` with no arguments. The helper reads the current directory's `mise.toml`; the config is the source of truth for tool selection. Group closely related tools in the module that owns their setup (for example editor support binaries).
- Prefer mise's core tool backends when available. A third-party backend or tool repository is acceptable only when it is maintained by the software's author or maintainer; otherwise treat it as questionable and choose another source.
- Before selecting a mise backend, verify that its actual release assets support the repository's target operating systems and architectures; do not assume a GitHub project has compatible downloadable assets.
- Treat mise declaratively: module `mise.toml` is the source of truth, and `mise_install_module` links it into `MISE_CONFIG_DIR/conf.d/<module>.toml` and installs its declared tools. Keep installer logic for post-install steps that cannot be represented in the config, and shell activation/PATH integration in focused module `*.zsh` files.
- When a mise-managed tool installs global executables under a configurable tool-owned root, point that root at the active mise installation and add only its `bin` directory to `PATH`. Avoid separate legacy install roots or adding the entire tool installation root to `PATH`.
- Installers and helpers use the current module directory for `Brewfile`, `mise.toml`, and relative symlink sources; module scripts should not need to repeat a module path when calling helpers.
- The user's global `MISE_CONFIG_DIR/config.toml` is regular and user-managed; do not symlink or overwrite it from a module installer.
- mise is a required, user-installed prerequisite alongside Homebrew. `script/setup` checks for it and activates it; do not install mise from the dotfiles setup.
- Use shared helpers instead of duplicating behavior: `check_command`, `info`, `fail`, `link_file`, and `remote_bash_install`.
- Make installers idempotent. Check whether a tool or directory already exists before installing it, and emit an informative message when skipping work.
- Remote installers must use `remote_bash_install` so they run with `CI=true` and `SHELL=/bin/false`, avoiding unwanted shell-profile changes.

## Configuration and shell integration

- Store managed configuration in a `*.symlink` directory and link it into its destination with `link_file`.
- Put shell setup in focused `*.zsh` files such as `path.zsh`, `init.zsh`, `aliases.zsh`, or `completion.zsh` when appropriate.
- Do not overwrite user files directly. `link_file` preserves an existing destination as a `.backup` before linking.

## Commits

- Follow the repository's scoped, imperative commit format: `<scope>: <verb> <concise description>`, for example `opencode: update skills and caveman parser`.
- Use the affected top-level module as the scope, such as `opencode`, `macos`, `nodejs`, `script`, or `docs`. Do not use Conventional Commit type prefixes such as `chore(scope):`.
- Stage and commit only files relevant to that scope. Do not include unrelated working-tree changes.

## Validation

- Run `bash -n` on every changed shell script.
- For a module installer, verify its `Brewfile` when present, local `mise.toml`, symlink source paths, and referenced commands or URLs.
- Do not run `script/setup` during routine validation because it installs or upgrades all modules. Run a targeted module installer only when its effects are intended.
- The repository intentionally supports rerunning installers safely.

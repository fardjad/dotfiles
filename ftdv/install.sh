#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
("$DOTFILES/rust/install.sh")
mise_install_module

if command -v ftdv > /dev/null 2>&1; then
  bash_completion_dir="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions"
  mkdir -p "$bash_completion_dir"
  ftdv completions bash > "$bash_completion_dir/ftdv"
else
  info "skipping ftdv Bash completions: ftdv is not installed or not on PATH"
fi

#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
mkdir -p "$config_dir"
link_file "herdr.symlink/config.toml" "$config_dir/config.toml"

mise_install_module

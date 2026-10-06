#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
mise_install_module

if is_mac; then
  hotkeys_path="$HOME/Library/Application Support/superfile/hotkeys.toml"
else
  hotkeys_path="$HOME/.config/superfile/hotkeys.toml"
fi

mkdir -p "$(dirname "$hotkeys_path")"
link_file "./hotkeys.toml" "$hotkeys_path"
superfile_config_dir="$(dirname "$hotkeys_path")"
link_file "./config.toml" "$superfile_config_dir/config.toml"

mkdir -p "$superfile_config_dir/theme"
link_file "./base16-eighties.toml" "$superfile_config_dir/theme/base16-eighties.toml"

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

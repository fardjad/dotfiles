#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command node; then
  user 'make sure node.js is installed before running nvim'
fi

if ! check_command python && ! check_command python3; then
  user 'make sure python is installed before running nvim'
fi

user 'you can optionally install gdu (https://github.com/dundee/gdu) for disk usage toggle terminal'

user "it's recommended to install one of the patched fonts available at https://www.nerdfonts.com/font-downloads"

should_exit=0
NVIM_CONFIG="$HOME/.config/nvim"
if [ -e "$NVIM_CONFIG" ]; then
  user "$NVIM_CONFIG already exists, skipping"
  should_exit=1
fi
NVIM_SHARED="$HOME/.local/share/nvim"
if [ -e "$NVIM_SHARED" ]; then
  user "$NVIM_SHARED already exists, skipping"
  should_exit=1
fi
if [ "$should_exit" -eq 1 ]; then
  exit 0
fi
git clone https://github.com/fardjad/astronvim_config "$HOME/.config/nvim"

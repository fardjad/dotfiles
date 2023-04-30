#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install nvim
brew_install tree-sitter
brew_install ripgrep
brew_install lazygit
brew_install bottom

if ! check_command node; then
  user 'make sure node.js is installed before running nvim'
fi

if ! check_command python && ! check_command python3; then
  user 'make sure python is installed before running nvim'
fi

user 'you can optionally install gdu (https://github.com/dundee/gdu) for disk usage toggle terminal'
user "it's recommended to install one of the patched fonts available at https://www.nerdfonts.com/font-downloads"

NVIM_CONFIG="$HOME/.config/nvim"
if [ -e "$NVIM_CONFIG" ]; then
  user "$NVIM_CONFIG already exists, skipping"
  exit 0
fi

NVIM_SHARED="$HOME/.local/share/nvim"
if [ -e "$NVIM_SHARED" ]; then
  user "$NVIM_SHARED already exists, skipping"
  exit 0
fi

git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"
link_file "./user_config.symlink" "$NVIM_CONFIG/lua/user"

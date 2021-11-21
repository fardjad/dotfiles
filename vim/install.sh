#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if is_mac; then
    if check_command brew; then
        brew_install vim
        brew_install nvim
    else
        fail 'brew must be installed'
    fi
else
    user 'make sure to install the latest version of vim with +clipboard feature enabled using your distro package manager'
fi

brew_install python

if ! check_command npm; then
    user 'make sure node.js is installed before running vim'
fi

user 'run "vim +PlugInstall +qall" to install the plugins'
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"
user 'run "ln -s '$DOTFILES'/vim/vimrc.symlink '$NVIM_CONFIG_DIR'/init.vim" to use the same config for Neovim'

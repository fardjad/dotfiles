#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if is_mac; then
    if check_command brew; then
        brew_install vim
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

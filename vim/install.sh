#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
    brew_install vim
else
    fail 'brew must be installed'
fi

brew_install python

if ! check_command npm; then
    user 'make sure node.js is installed before running vim'
fi

user 'run "vim +PlugInstall +qall" to install the plugins'

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install git
brew_install zsh

brew_install antidote

link_file "./fsh.symlink" "$HOME/.fsh"
link_file "./zsh_plugins.txt.symlink" "$HOME/.zsh_plugins.txt"

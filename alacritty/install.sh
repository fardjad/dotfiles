#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command alacritty; then
  user "to install alacritty config, create a symlink from $PWD/.alacritty.yml to $HOME/.alacritty.yml"
fi

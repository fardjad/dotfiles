#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command brew; then
  fail 'brew must be installed'
fi

link_file "./starship.symlink" "$HOME/.starship"

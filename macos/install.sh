#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! is_mac; then
  info "This machine is not running macOS. Skipping..."
  exit 0
fi

brew_bundle_install

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"
user "run 'brew autoupdate start 43200 --upgrade --cleanup --immediate --sudo' to enable auto update for brew"

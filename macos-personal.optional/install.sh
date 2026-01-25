#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! is_mac; then
  info "This machine is not running macOS. Skipping..."
  exit 0
fi

brew_bundle_install

user "run $DOTFILES/macos-personal.optional/brave-browser/set-group-policy.sh to configure Brave Browser"

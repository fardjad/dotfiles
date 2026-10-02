#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
brew_bundle_install

BASH_PATH="$(brew --prefix)/bin/bash"
if ! grep -q "$BASH_PATH" /etc/shells; then
  info "adding $BASH_PATH to /etc/shells"
  echo "$BASH_PATH" | sudo tee -a /etc/shells
fi

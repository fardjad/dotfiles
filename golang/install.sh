#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install git
brew_install mercurial
brew_install bison
brew_install protobuf
# Install a bootstrap version. It might not be needed but it doesn't hurt to have it anyways
brew_install golang

if ! check_command "gvm"; then
  [ -d "$HOME/.gvm" ] && rm -rf "$HOME/.gvm"

  export GVM_NO_UPDATE_PROFILE=1
  $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)"

  [ -s "$HOME/.gvm/scripts/gvm" ] && . "$HOME/.gvm/scripts/gvm"

  LATEST_GO_VERSION="$(curl -sSL 'https://go.dev/VERSION?m=text')"
  gvm install "$LATEST_GO_VERSION" -pb -b && gvm use "$LATEST_GO_VERSION" --default
fi

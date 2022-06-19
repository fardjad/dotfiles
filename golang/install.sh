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

if ! is_mac; then
  go env -w CC=gcc CXX="g++"
fi

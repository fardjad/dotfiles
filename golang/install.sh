#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
brew_bundle_install
mise_install_module

if ! is_mac; then
  mise exec -- go env -w CC=gcc CXX="g++"
fi

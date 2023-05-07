#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! is_mac; then
  go env -w CC=gcc CXX="g++"
fi

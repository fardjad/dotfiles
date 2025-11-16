#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command "bun"; then
  remote_bash_install https://bun.sh/install
else
  info 'bun is already intalled. Run "bun upgrade" to upgrade its executable'
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command "deno"; then
  curl -fsSL https://deno.land/install.sh | sh
else
  info 'deno is already intalled. Run "deno upgrade" to upgrade its executable'
fi

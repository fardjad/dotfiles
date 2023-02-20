#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
  brew_install unzip
  brew_install curl
else
  fail 'brew must be installed'
fi

if ! check_command "deno"; then
  curl -fsSL https://deno.land/install.sh | sh
else
  info 'deno is already intalled. Run "deno upgrade" to upgrade its executable'
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install exa
info "it's recommended to install one of the patched fonts available at https://www.nerdfonts.com/font-downloads"

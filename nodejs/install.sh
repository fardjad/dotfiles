#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

export NVS_HOME="$HOME/.nvs"
if [ ! -d "$NVS_HOME" ]; then
  export NVS_SHELL_PROFILE=/dev/null
  git clone https://github.com/jasongin/nvs "$NVS_HOME"
  . "$NVS_HOME/nvs.sh" install
else
  info 'nvs is already installed.'
fi

if ! check_command "node"; then
  if ! check_command "nvs"; then
    [ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"
  fi

  nvs add lts
  nvs link lts
  nvs use lts
fi

corepack enable

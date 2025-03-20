#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command "pipenv"; then
  pipx install pipenv
else
  info 'pipenv is already installed.'
fi

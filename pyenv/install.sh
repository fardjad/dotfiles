#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install openssl
brew_install readline
brew_install sqlite3
brew_install xz
brew_install zlib
brew_install pyenv
brew_install pyenv-virtualenv
brew_install tcl-tk

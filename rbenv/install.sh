#!/usr/bin/env bash

set -e

# shellcheck source=../script/bootstrap.bash
source "$(dirname "$0")/../script/bootstrap.bash"

brew_install rbenv
brew_install ruby-build

VERSION="$(rbenv install -l | grep -v '-' | sort --version-sort -r | head -n1)"
eval "$(rbenv init - bash)"
rbenv install -s "$VERSION"
rbenv global "$VERSION"

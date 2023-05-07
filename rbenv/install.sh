#!/usr/bin/env bash

set -e

# shellcheck source=../script/bootstrap.bash
source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if is_codespaces; then
  # TODO: figure out how to install ruby in codespaces
  exit 0
fi

VERSION="$(rbenv install -l | grep -v '-' | sort --version-sort -r | head -n1)"
eval "$(rbenv init - bash)"
rbenv install -s "$VERSION"
rbenv global "$VERSION"

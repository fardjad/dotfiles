#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y -q

source "$HOME/.cargo/env"

rustup component add rustfmt

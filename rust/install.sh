#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
    brew_install rustup-init
else
    fail 'brew must be installed'
fi

rustup-init --no-modify-path -y
source "$HOME/.cargo/env"

if check_command rustup; then
    rustup component add rustfmt
else
    fail 'rustup is not in path!'
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! [ -s "$HOME/.cargo/env" ]; then
    if is_mac; then
        if check_command brew; then
            brew_install rustup-init
        else
            fail 'brew must be installed'
        fi

        rustup-init --no-modify-path -y
    else
        if check_command brew; then
            brew_install curl
        else
            fail 'brew must be installed'
        fi

        curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
    fi
else
    info "$HOME/.cargo/env already exists" 
fi

source "$HOME/.cargo/env"

if ! check_command rustfmt; then
    rustup component add rustfmt
else
    info 'rustfmt is already installed'
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if is_mac; then
    if ! check_command brew; then
        fail 'brew must be installed'
    fi

    brew_tap 'getantibody/tap'
    brew_install antibody
else
    curl -sL https://git.io/antibody | sh -s
fi

rm -rf $(antibody home)
antibody bundle <"$DOTFILES/antibody/bundles.txt" >~/.zsh_plugins.sh
antibody update

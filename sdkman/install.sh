#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
    brew_install curl
else
    fail 'brew must be installed'
fi

export SDKMAN_DIR="$HOME/.sdkman"

if [ ! -d "$SDKMAN_DIR" ]; then 
    curl -s "https://get.sdkman.io" | sed 's!^sdkman_bashrc=".*"$!sdkman_bashrc=/dev/null!' | sed 's!^sdkman_zshrc=".*"$!sdkman_zshrc=/dev/null!' | bash
else
    info 'sdkman is already installed.'
fi

if ! check_command "sdkman"; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

sdk install java 11.0.3.hs-adpt
sdk default java 11.0.3.hs-adpt

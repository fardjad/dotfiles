#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
    brew_install git
else
    fail 'brew must be installed'
fi

export NVS_HOME="$HOME/.nvs"

if [ ! -d "$NVS_HOME" ]; then 
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
fi

if ! check_command "yarn"; then
    npm install -g yarn
fi

if ! check_command "elm"; then
    npm install -g elm
fi

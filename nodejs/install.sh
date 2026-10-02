#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
mise_install_module

mise_env="$(mise -C "$HOME" env -s bash)"
eval "$mise_env"

npm install -g corepack@latest
npm install -g npm@latest
corepack enable

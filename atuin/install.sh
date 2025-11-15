#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

export ATUIN_NO_MODIFY_PATH=1
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | sh

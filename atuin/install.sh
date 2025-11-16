#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

export ATUIN_NO_MODIFY_PATH=1
remote_bash_install https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh

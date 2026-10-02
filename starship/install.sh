#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"

link_file "./starship.symlink" "$HOME/.starship"

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

readonly JCODE_INSTALLER_URL='https://raw.githubusercontent.com/fardjad/jcode/personalized/install.sh'

remote_bash_install "$JCODE_INSTALLER_URL"

mkdir -p "$HOME/.jcode"
link_file "./jcode.symlink/config.toml" "$HOME/.jcode/config.toml"
link_file "./jcode.symlink/swarm-prompt.md" "$HOME/.jcode/swarm-prompt.md"

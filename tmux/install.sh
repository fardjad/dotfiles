#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
  brew_install tmux
else
  fail 'brew must be installed'
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  user 'run tmux and press prefix+I to install the plugins'
fi

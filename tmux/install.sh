#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! is_mac; then
  if ! check_command xclip; then
    user 'for clipboard integration, make sure to have xclip installed'
  fi

  if ! check_command wl-copy; then
    user 'for clipboard integration, make sure to have wl-clipboard installed'
  fi
fi

link_file "./tmux.conf.symlink" "$HOME/.tmux.conf"
link_file "./tmux.symlink" "$HOME/.tmux"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  user 'run tmux and press prefix+I to install the plugins'
fi

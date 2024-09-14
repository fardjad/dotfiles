#!/usr/bin/env bash

tmux source-file "$HOME/.tmux/paste-common.tmux.conf"

if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
  if [ -x "$(command -v wl-copy)" ]; then
    set -s copy-command "wl-copy -p"
  fi

  if [ -x "$(command -v wl-paste)" ]; then
    tmux source-file "$HOME/.tmux/paste-wl-clipboard.tmux.conf"
  fi
elif [ "$XDG_SESSION_TYPE" == "x11" ]; then
  if [ -x "$(command -v xclip)" ]; then
    tmux source-file "$HOME/.tmux/paste-xclip.tmux.conf"
  fi
fi

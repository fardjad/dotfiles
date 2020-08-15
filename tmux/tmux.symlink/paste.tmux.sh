#!/usr/bin/env bash

tmux source-file "$HOME/.tmux/paste-common.tmux.conf"

if [ "$XDG_SESSION_TYPE" = "x11" ] && [ -x "$(command -v xclip)" ]; then
  tmux source-file "$HOME/.tmux/paste-xclip.tmux.conf"
fi

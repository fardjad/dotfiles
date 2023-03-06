#!/usr/bin/env bash

tmux source-file "$HOME/.tmux/paste-common.tmux.conf"

if [ -n "$DISPLAY" ] && [ -x "$(command -v xclip)" ]; then
  tmux source-file "$HOME/.tmux/paste-xclip.tmux.conf"
fi

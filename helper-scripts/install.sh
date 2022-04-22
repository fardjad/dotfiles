#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

BASE_DIR="$HOME/.helper-scripts"
mkdir -p "$BASE_DIR" 2>&1 > /dev/null

COMMON_DIR="$BASE_DIR/common"
MAC_DIR="$BASE_DIR/macos"
LINUX_DIR="$BASE_DIR/linux"

[ -d "$COMMON_DIR" ] || ln -sf "$DOTFILES/helper-scripts/common/" "$COMMON_DIR"

if is_mac; then
  [ -d "$MAC_DIR" ] || ln -sf "$DOTFILES/helper-scripts/macos/" "$MAC_DIR"
else
  [ -d "$LINUX_DIR" ] || ln -sf "$DOTFILES/helper-scripts/linux/" "$LINUX_DIR"
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

readonly JCODE_INSTALLER_URL='https://raw.githubusercontent.com/fardjad/jcode/personalized/install.sh'
readonly JCODE_REPOSITORY='https://github.com/fardjad/jcode.git'
readonly JCODE_BRANCH='personalized'
readonly JCODE_SOURCE_DIR="$HOME/.jcode/source"

remote_bash_install "$JCODE_INSTALLER_URL"

brew_bundle_install

if [ -d "$JCODE_SOURCE_DIR/.git" ]; then
  if [ -n "$(git -C "$JCODE_SOURCE_DIR" status --porcelain)" ]; then
    fail "Jcode source is dirty: $JCODE_SOURCE_DIR"
  fi
elif [ -e "$JCODE_SOURCE_DIR" ]; then
  fail "$JCODE_SOURCE_DIR exists but is not a git repository"
else
  info 'cloning Jcode plugin source'
  git clone --branch "$JCODE_BRANCH" "$JCODE_REPOSITORY" "$JCODE_SOURCE_DIR"
fi

mkdir -p "$HOME/.jcode"
link_file "./jcode.symlink/config.toml" "$HOME/.jcode/config.toml"
link_file "./jcode.symlink/prompt-overlay.md" "$HOME/.jcode/prompt-overlay.md"
link_file "./jcode.symlink/swarm-prompt.md" "$HOME/.jcode/swarm-prompt.md"

mkdir -p "$HOME/.jcode/plugins"
install -m 755 "$JCODE_SOURCE_DIR/plugins/rtk/rtk-transform" \
  "$HOME/.jcode/plugins/rtk-transform"

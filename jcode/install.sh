#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

readonly JCODE_REPOSITORY='https://github.com/fardjad/jcode.git'
readonly JCODE_UPSTREAM_REPOSITORY='https://github.com/1jehuang/jcode.git'
readonly JCODE_BRANCH='personalized'
readonly JCODE_SOURCE_DIR="$HOME/.jcode/source"

brew_bundle_install

if [ -d "$JCODE_SOURCE_DIR/.git" ]; then
  if [ -n "$(git -C "$JCODE_SOURCE_DIR" status --porcelain)" ]; then
    fail "Jcode source is dirty: $JCODE_SOURCE_DIR"
  fi
elif [ -e "$JCODE_SOURCE_DIR" ]; then
  fail "$JCODE_SOURCE_DIR exists but is not a git repository"
else
  info 'cloning Jcode source'
  mkdir -p "$(dirname "$JCODE_SOURCE_DIR")"
  git clone --branch "$JCODE_BRANCH" "$JCODE_REPOSITORY" "$JCODE_SOURCE_DIR"
  git -C "$JCODE_SOURCE_DIR" remote add upstream "$JCODE_UPSTREAM_REPOSITORY"
fi

mkdir -p "$HOME/.jcode"
link_file "./jcode.symlink/config.toml" "$HOME/.jcode/config.toml"
link_file "./jcode.symlink/swarm-prompt.md" "$HOME/.jcode/swarm-prompt.md"

pushd "$JCODE_SOURCE_DIR" > /dev/null
just install-patched-version
popd > /dev/null

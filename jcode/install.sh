#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"

readonly JCODE_REPOSITORY='https://github.com/fardjad/jcode.git'
readonly JCODE_BRANCH='personalized'
readonly JCODE_SOURCE_DIR="$HOME/.jcode/source"

if check_command jcode && [ "${JCODE_FORCE_INSTALL:-0}" != "1" ]; then
  info 'Jcode is already installed; skipping installation (set JCODE_FORCE_INSTALL=1 to override)'
  exit 0
fi

if [ "${JCODE_FORCE_INSTALL:-0}" = "1" ]; then
  info 'forcing Jcode source installation'
fi

brew_bundle_install

"$DOTFILES/just/install.sh"
"$DOTFILES/rust/install.sh"

if [ -d "$JCODE_SOURCE_DIR/.git" ]; then
  if [ -n "$(git -C "$JCODE_SOURCE_DIR" status --porcelain)" ]; then
    fail "Jcode source is dirty: $JCODE_SOURCE_DIR"
  fi
  if [ "$(git -C "$JCODE_SOURCE_DIR" branch --show-current)" != "$JCODE_BRANCH" ]; then
    fail "Jcode source must be checked out on branch $JCODE_BRANCH: $JCODE_SOURCE_DIR"
  fi
elif [ -e "$JCODE_SOURCE_DIR" ]; then
  fail "$JCODE_SOURCE_DIR exists but is not a git repository"
else
  info 'cloning Jcode source'
  git clone --branch "$JCODE_BRANCH" "$JCODE_REPOSITORY" "$JCODE_SOURCE_DIR"
fi

(
  cd "$JCODE_SOURCE_DIR"
  just install-patched-version
  just ensure-personal-assets
)

link_file "./jcode.symlink/config.toml" "$HOME/.jcode/config.toml"

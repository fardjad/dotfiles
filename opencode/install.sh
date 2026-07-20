#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command bun; then
  "$(dirname "$0")/../bun/install.sh"
  source ../bun/path.zsh
fi

mkdir -p "$HOME/.config"
link_file "./opencode.symlink" "$HOME/.config/opencode"

bun x oh-my-opencode-slim@latest install \
  --no-tui \
  --skills=force \
  --companion=no \
  --background-subagents=yes \
  --background-subagents-target="$PWD/init.zsh"

bun x github:JuliusBrussee/caveman -- \
  --only opencode \
  --non-interactive

for skill in $(cat skills.txt); do
  bun x skills add "$skill" -g -a opencode -y
done

rtk init -g --opencode

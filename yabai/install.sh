#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! is_mac; then
  info "This machine is not running macOS. Skipping..."
  exit 0
fi

brew_bundle_install

user 'make sure to follow the docs to disable SIP: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection'

YABAI_PATH=$(which yabai)
SHA_SUM=$(shasum -a 256 "$YABAI_PATH" | awk '{ print $1 }')

cat << EOF | sudo tee /private/etc/sudoers.d/yabai
ALL ALL=(root) NOPASSWD: sha256:$SHA_SUM $YABAI_PATH --load-sa
EOF

YABAI_CONFIG_PATH="$HOME/.config/yabai/yabairc"
mkdir -p "$(dirname "$YABAI_CONFIG_PATH")"
link_file "./yabairc.symlink" "$YABAI_CONFIG_PATH" || true

SKHD_CONFIG_PATH="$HOME/.config/skhd/skhdrc"
mkdir -p "$(dirname "$SKHD_CONFIG_PATH")"
link_file "./skhdrc.symlink" "$SKHD_CONFIG_PATH" || true

user "run 'skhd --start-service' and grant it accessibility permissions"
user "run 'yabai --start-service' and grant it accessibility permissions"

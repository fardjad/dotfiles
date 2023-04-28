#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! is_mac; then
  info "This machine is not running macOS. Skipping..."
  exit 0
fi

if ! check_command "brew"; then
  fail "brew must be installed!"
fi

taps="
homebrew/cask-fonts
buo/cask-upgrade
homebrew/cask-versions
"
for tap in $taps; do
  brew_tap "$tap"
done

# brew list --cask -1
cask_packages="
alfred
appcleaner
brewlet
cryptomator
deepl
ferdium
font-fira-code-nerd-font
github
iterm2
keka
linearmouse
macfuse
menumeters
mongodb-compass
moom
mountain-duck
ngrok
notion
obs
openlens
pastebot
plex
postman
visual-studio-code
vlc
"
for package in $cask_packages; do
  brew_cask_install "$package"
done

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"

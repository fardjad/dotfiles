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
caskroom/fonts
buo/cask-upgrade
"
for tap in $taps; do
    brew_tap "$tap"
done

cask_packages="
alfred
appcleaner
boxcryptor
docker
dropbox
firefox
font-fira-code
igetter
iterm2
joplin
karabiner-elements
keka
lightworks
macpass
protonvpn
spotify
telegram
virtualbox
virtualbox-extension-pack
visual-studio-code
"
for package in $cask_packages; do
    brew_cask_install "$package"
done

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"

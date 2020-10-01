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

cask_packages="
alfred
appcleaner
bitwarden
brave-browser
cryptomator
docker
firefox
font-fira-code
hiddenbar
iterm2
joplin
karabiner-elements
keka
lepton
menumeters
mongodb-compass
nextcloud
ngrok
postman
protonvpn
rambox
skype
spotify
syncthing
telegram
veracrypt
virtualbox
virtualbox-extension-pack
visual-studio-code
vlc
"
for package in $cask_packages; do
    brew_cask_install "$package"
done

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"

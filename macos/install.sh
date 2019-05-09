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
altair-graphql-client
anaconda
appcleaner
avidemux
bitbar
boxcryptor
cheatsheet
deluge
docker
dozer
drawio
dropbox
eloston-chromium
firefox
flycut
font-fira-code
handbrake
igetter
insomnia
iterm2
java
joplin
karabiner-elements
keka
lepton
lightworks
macpass
macvim
menumeters
moom
ngrok
pgadmin4
postgres
protonvpn
skype
spotify
tableplus
tad
telegram
tor-browser
vienna
virtualbox
virtualbox-extension-pack
visual-studio-code
vlc
"
for package in $cask_packages; do
    brew_cask_install "$package"
done

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"

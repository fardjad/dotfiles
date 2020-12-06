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
android-platform-tools
anydesk
appcleaner
balenaetcher
bitwarden
charles
cryptomator
deepl
docker
eqmac
firefox
font-fira-code
github
iterm2
joplin
karabiner-elements
keepassxc
keka
lens
lepton
menumeters
miro
mongodb-compass
moom
nextcloud
ngrok
obs
osxfuse
pastebot
postman
protonvpn
rambox
skype
slack
sourcetree
spotify
steam
syncthing
telegram
vagrant
veracrypt
virtualbox
virtualbox-extension-pack
visual-studio-code
vlc
whatsapp
zoho-mail
"
for package in $cask_packages; do
    brew_cask_install "$package"
done

user "run $DOTFILES/macos/setup-macos.sh to setup macOS"

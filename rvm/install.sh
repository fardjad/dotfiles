#!/usr/bin/env bash

set -e

# shellcheck source=../script/bootstrap.bash
source "$(dirname "$0")/../script/bootstrap.bash"

function install_keys() {
  GPG_COMMAND="gpg2"

  if is_mac; then
    brew_install gnupg2
    GPG_COMMAND="gpg"
  elif ! check_command gpg2; then
    user 'gpg2 is not in path. install gnupg2 using your distro package manager and run the installer script again.'
    exit 0
  fi

  gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
}

RVM="$HOME/.rvm"

if ! check_command rvm; then
  install_keys
  [ -d "$RVM" ] && rm -rf "$RVM"

  \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
fi

# shellcheck source=/dev/null
source "$RVM/scripts/rvm"

if is_mac; then
  rvm get stable --autolibs=homebrew
else
  rvm get stable
fi

# for some reason --latest doesn't select the newest version
VERSION="$(rvm list remote | grep -oE 'ruby-[0-9]+.*' | sort -r --version-sort | head -n1)"
rvm install ruby "$VERSION" --binary
rvm use "$VERSION" --install --default --create

user "run rvm reload to use the newly installed ruby"

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command gpg2; then
  user 'gpg2 is not in path. install gnupg2 using your distro package manager and run the installer script again.'
    exit 0
fi

if ! check_command rvm; then
    RVM="$HOME/.rvm"
    [ -d "$RVM" ] && rm -rf "$RVM"

    gpg2 --keyserver hkp://keys.gnupg.net --receive-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
    source "$RVM/scripts/rvm"
fi

RUBY_VERSION="2.7.1"
rvm get stable --autolibs=homebrew
rvm install "ruby-${RUBY_VERSION}"
rvm alias create default "${RUBY_VERSION}"

user "run rvm reload to use the newly installed ruby"

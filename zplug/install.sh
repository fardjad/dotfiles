#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command brew; then
  fail 'brew must be installed'
fi

brew_install curl
brew_install git
brew_install zsh

ZSH_PATH="$(brew --prefix)/bin/zsh"
ZPLUG_HOME="$HOME/.zplug"

if [ ! -d "$ZPLUG_HOME" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | "$ZSH_PATH"
else
  info 'zplug is already installed.'
fi

user "run 'rm $ZPLUG_HOME/repos/zsh-users/zsh-autosuggestions/.ruby-version' to remove the ruby version nag message on shell startup. Alternatively, install the missing ruby version with rvm"

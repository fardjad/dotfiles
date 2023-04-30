#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if check_command brew; then
  brew_install zsh
else
  fail 'brew must be installed'
fi

ZSH_PATH="$(brew --prefix)/bin/zsh"
if ! grep -q "$ZSH_PATH" /etc/shells; then
  info "adding $ZSH_PATH to /etc/shells"
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

if is_mac; then
  chsh -u $(whoami) -s "$ZSH_PATH"
else
  sudo chsh $(whoami) -s "$ZSH_PATH"
fi

link_file "./zshrc.symlink" "$HOME/.zshrc"

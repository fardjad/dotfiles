#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
("$DOTFILES/rust/install.sh")
mise_install_module
user "it's recommended to install one of the patched fonts available at https://www.nerdfonts.com/font-downloads"

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

user "it's recommended to install one of the patched fonts available at https://www.nerdfonts.com/font-downloads"

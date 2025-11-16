#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

dotnet_install() {
  remote_bash_install "https://dot.net/v1/dotnet-install.sh" "$@"
}

export DOTNET_INSTALL_DIR="${HOME}/.dotnet"
dotnet_install --channel 8.0
dotnet_install --channel 9.0
dotnet_install # latest LTS

user "follow https://learn.microsoft.com/en-us/dotnet/core/versions/selection for selecting the .NET version"

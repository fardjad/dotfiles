#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

chmod +x "$(dirname "$0")/skills-server/skills-server"

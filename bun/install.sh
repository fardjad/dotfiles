#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! check_command "bun"; then
	curl -fsSL https://bun.sh/install | SHELL=/bin/false bash
else
	info 'bun is already intalled. Run "bun upgrade" to upgrade its executable'
fi

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

export SDKMAN_DIR="$HOME/.sdkman"

if [ ! -d "$SDKMAN_DIR" ]; then
  curl -s "https://get.sdkman.io" | sed 's!^sdkman_bashrc=".*"$!sdkman_bashrc=/dev/null!' | sed 's!^sdkman_zshrc=".*"$!sdkman_zshrc=/dev/null!' | bash
else
  info 'sdkman is already installed.'
fi

if ! check_command "sdkman"; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

export sdkman_auto_answer=true
export auto_answer_upgrade=true

sdk update > /dev/null

# install the latest version of Temurin (for more info, see: https://sdkman.io/jdks)
JAVA_VERSION="$(sdk ls java | grep -Ev 'local only' | awk -F '|' '{ print $6 }' | grep '\-tem' | sort -r -V | head -n1)"
sdk install java $JAVA_VERSION > /dev/null || true
sdk default java $JAVA_VERSION > /dev/null

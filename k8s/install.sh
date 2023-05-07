#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

brew_bundle_install

if ! docker info &> /dev/null; then
  fail "docker engine is not ready! make sure it is running and $USER belongs to docker group"
fi

DOCKER_CLI_PLUGINS_PATH="$HOME/.docker/cli-plugins"
mkdir -p "$DOCKER_CLI_PLUGINS_PATH"
ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" "$DOCKER_CLI_PLUGINS_PATH/docker-compose"

# krew
info 'Installing krew...'

KREW_ROOT="$HOME/.krew"
[ ! -d "$KREW_ROOT" ] && (
  cd "$(mktemp -d)" \
    && OS="$(uname | tr '[:upper:]' '[:lower:]')" \
    && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
    && KREW="krew-${OS}_${ARCH}" \
    && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" \
    && tar zxvf "${KREW}.tar.gz" \
    && ./"${KREW}" install krew
)
export PATH="$KREW_ROOT/bin:$PATH"

krew_install() {
  kubectl krew install "$1" 2>&1 \
    | sed '/^Updated the local copy of plugin index.*/d' \
    | sed '/^W0505.*/d' \
    | sed 's/^/  [krew] /'
}

# install krew plugins
krew_install ctx
krew_install ns

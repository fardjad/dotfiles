#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command docker; then
  user 'docker is not installed/configured. Setup docker and re-run the installation script'
  exit 0
fi

if ! docker info &> /dev/null; then
  fail "docker engine is not ready! make sure it is running and $USER belongs to docker group"
fi

brew_install docker-compose
DOCKER_CLI_PLUGINS_PATH="$HOME/.docker/cli-plugins"
mkdir -p "$DOCKER_CLI_PLUGINS_PATH"
ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" "$DOCKER_CLI_PLUGINS_PATH/docker-compose"

brew_install kubernetes-cli
brew_install minikube
brew_install helm
brew_install fzf

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

# install krew plugins
kubectl krew install ctx
kubectl krew install ns

info 'Pulling kicbase image...'
BASE_IMAGE="$(minikube start --help | sed -En "s:^.*base-image='([^@]+).*:\1:p")"
docker pull -q "$BASE_IMAGE" > /dev/null

user 'you can now start your minikube cluster by running minikube start'

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command docker; then
  user 'docker is not installed/configured. Setup docker and re-run the installation script'
  exit 0
fi

if ! docker info &>/dev/null; then
  fail "docker engine is not ready! make sure it is running and $USER belongs to docker group"
fi

brew_install minikube
brew_install helm
brew_install skaffold
brew_install ksync

brew_install docker-compose
brew_install kompose

# krew
info 'Installing krew...'

brew_install fzf

KREW_ROOT="$HOME/.krew"
[ ! -d "$KREW_ROOT" ] && (
  cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" &&
  "$KREW" install krew &&
  export PATH="$KREW_HOME:$PATH"
)

# install krew plugins
kubectl krew install ctx
kubectl krew install ns

info 'Pulling kicbase image...'
BASE_IMAGE="$(minikube start --help | sed -En "s:^.*base-image='([^@]+).*:\1:p")"
docker pull -q "$BASE_IMAGE" >/dev/null

user 'you can now start your minikube cluster by running minikube start'

#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../script/bootstrap.bash"

if ! check_command docker; then
  fail 'docker must be installed'
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

info 'Pulling kicbase image...'
BASE_IMAGE="$(minikube start --help | sed -En "s:^.*base-image='([^@]+).*:\1:p")"
docker pull -q "$BASE_IMAGE" >/dev/null

user 'you can now start your minikube cluster by running minikube start'

#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"
mise_install_module

if ! mise exec -- docker info &> /dev/null; then
  fail "docker engine is not ready! make sure it is running and $USER belongs to docker group"
fi

DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
DOCKER_CLI_PLUGINS_PATH="$DOCKER_CONFIG/cli-plugins"
mkdir -p "$DOCKER_CLI_PLUGINS_PATH"
DOCKER_COMPOSE_PATH="$(mise which docker-compose)"
DOCKER_BUILDX_PATH="$(mise which docker-buildx)"
if [ ! -x "$DOCKER_COMPOSE_PATH" ] || [ ! -x "$DOCKER_BUILDX_PATH" ]; then
  fail 'mise did not resolve the Docker Compose and Buildx CLI plugins'
fi

ln -sfn "$DOCKER_COMPOSE_PATH" "$DOCKER_CLI_PLUGINS_PATH/docker-compose"
ln -sfn "$DOCKER_BUILDX_PATH" "$DOCKER_CLI_PLUGINS_PATH/docker-buildx"

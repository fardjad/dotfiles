#!/usr/bin/env bash

set -eo pipefail

load_mise_environment() {
  local mise_env
  mise_env="$(mise -C "$HOME" env -s bash)"
  eval "$mise_env"
}

if ! command -v mise > /dev/null 2>&1; then
  echo "mise is not installed. Please install it first." >&2
  exit 1
fi

load_mise_environment
if ! command -v node > /dev/null 2>&1 || ! command -v npm > /dev/null 2>&1; then
  echo "Node.js and npm are unavailable. Install the Node tool from the mise module first." >&2
  exit 1
fi

# Save package names only. They'll be reinstalled at latest after Node upgrades.
echo "Recording global npm package names..."
global_package_names="$(npm ls --global --depth=0 --json | node --input-type=module -e '
import { readFileSync } from "node:fs";

const packages = JSON.parse(readFileSync(0, "utf8")).dependencies || {};
for (const name of Object.keys(packages)) {
  if (name !== "npm" && name !== "corepack") console.log(name);
}
')"
global_packages=()
while IFS= read -r package; do
  if [[ -n "$package" ]]; then
    global_packages+=("$package@latest")
  fi
done <<< "$global_package_names"

printf 'Upgrading Node.js with mise...\n'
mise -C "$HOME" upgrade node
load_mise_environment

printf 'Installing the latest global npm packages...\n'
npm install --global corepack@latest
npm install --global npm@latest
if (( ${#global_packages[@]} > 0 )); then
  npm install --global "${global_packages[@]}"
fi
corepack enable

printf "Done. Review unused Node versions with 'mise prune --dry-run'.\n"

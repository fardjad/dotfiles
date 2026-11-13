#!/usr/bin/env bash
set -eu

repo_dir="$(cd "$(dirname "$0")/.." && pwd -P)"
mise_bin="$(command -v mise)"
zsh_bin="$(command -v zsh)"
brew_prefix="$(brew --prefix)"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

home="$test_dir/home"
mkdir -p "$home/.local/bin" "$home/.config/mise" "$test_dir/node/bin"
ln -s "$mise_bin" "$home/.local/bin/mise"
ln -s "$repo_dir/zsh/zshrc.symlink" "$home/.zshrc"
: > "$home/.zsh_plugins.txt"
cat > "$home/.zshenv" <<'EOF'
brew() {
  case "$*" in
    --prefix) printf '%s\n' "$TEST_BREW_PREFIX" ;;
    '--prefix antidote') printf '%s/opt/antidote\n' "$TEST_BREW_PREFIX" ;;
    *) return 1 ;;
  esac
}
EOF
printf '[tools]\nnode = "1.0.0"\n' > "$home/.config/mise/config.toml"
printf '#!/bin/sh\necho mise-test-node\n' > "$test_dir/node/bin/node"
chmod +x "$test_dir/node/bin/node"

cd "$home"
env -i HOME="$home" PATH=/usr/local/bin:/usr/bin:/bin "$mise_bin" link node@1.0.0 "$test_dir/node"
env -i HOME="$home" USER="$(id -un)" TERM=xterm PATH=/usr/local/bin:/usr/bin:/bin \
  TEST_BREW_PREFIX="$brew_prefix" HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 \
  "$zsh_bin" -ic '[[ "$(node)" == mise-test-node ]]' </dev/null

#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
source "../script/bootstrap.bash"

if [ "${XDG_CONFIG_HOME+x}" = x ] && [ -z "$XDG_CONFIG_HOME" ]; then
  fail 'XDG_CONFIG_HOME must not be empty'
fi
if [ "${XDG_STATE_HOME+x}" = x ] && [ -z "$XDG_STATE_HOME" ]; then
  fail 'XDG_STATE_HOME must not be empty'
fi

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
mkdir -p "$config_dir"
link_file "herdr.symlink/config.toml" "$config_dir/config.toml"

bash ../python/install.sh
mise_install_module

# Resolve tools through their owning module configs even without shell activation.
herdr_bin="$(mise which herdr --tool herdr)"
python_bin="$(mise -C "$DOTFILES/python" which python3 --tool python)"
[ -x "$herdr_bin" ] && [ -x "$python_bin" ] || fail 'mise did not provide Herdr and Python executables'
HERDR_BIN="$herdr_bin" "$python_bin" ./install-plugins.py

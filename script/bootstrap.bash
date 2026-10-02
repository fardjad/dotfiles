pushd "$(dirname "$0")/.." > /dev/null
export DOTFILES=$(pwd -P)
popd > /dev/null

export NONINTERACTIVE=1
export HOMEBREW_BUNDLE_NO_LOCK=1
export MODULE_DIR="$(pwd -P)"

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit -1
}

check_command() {
  command -v "$1" > /dev/null 2>&1
}

brew_bundle_install() {
  if ! check_command brew; then
    fail 'brew must be installed'
  fi

  brew bundle install -q "$@" \
    | sed '/^Homebrew Bundle complete.*/d' \
    | sed 's/^/  [brew] /'
}

mise_install_module() {
  if ! check_command mise; then
    fail 'mise must be installed and available on PATH'
  fi

  local module_dir="$(pwd -P)"
  local module_name
  module_name="$(basename "$module_dir")"
  local mise_conf_d="${MISE_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/mise}/conf.d"
  if [ ! -f "$module_dir/mise.toml" ]; then
    fail "mise module config not found: $module_dir/mise.toml"
  fi

  mkdir -p "$mise_conf_d"

  local legacy_name legacy_fragment legacy_source
  for legacy_name in atuin bat bun deno eza fzf gh lazygit neovim nodejs ripgrep starship tlrc uv; do
    legacy_fragment="$mise_conf_d/$legacy_name"
    legacy_source="$DOTFILES/mise/tools/$legacy_name.symlink"
    if [ -L "$legacy_fragment" ] && [ "$(readlink "$legacy_fragment")" = "$legacy_source" ]; then
      rm "$legacy_fragment"
      info "removed legacy mise fragment link: $legacy_fragment"
    fi
  done

  local config_link="$mise_conf_d/$module_name.toml"
  if [ -e "$config_link" ] || [ -L "$config_link" ]; then
    if [ -L "$config_link" ] && [ "$(readlink -f "$config_link")" = "$module_dir/mise.toml" ]; then
      info "mise config already linked: $config_link"
    else
      user "leaving unmanaged mise config unchanged: $config_link"
      return 0
    fi
  else
    link_file "$module_dir/mise.toml" "$config_link"
  fi

  local -a tools=()
  local tool_name
  while IFS= read -r tool_name; do
    [ -n "$tool_name" ] && tools+=("$tool_name")
  done < <(awk '
    /^[[:space:]]*\[tools\][[:space:]]*(#.*)?$/ { section = "managed"; next }
    /^[[:space:]]*\[tool_alias\][[:space:]]*(#.*)?$/ { section = "managed"; next }
    /^[[:space:]]*\[/ { section = "" }
    section == "managed" && /=/ {
      key = $0
      sub(/[[:space:]]+#.*/, "", key)
      sub(/=.*/, "", key)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
      if (substr(key, 1, 1) == "\"" || substr(key, 1, 1) == "\047") {
        key = substr(key, 2, length(key) - 2)
      }
      if (!seen[key]++) print key
    }
  ' "$module_dir/mise.toml")

  if [ "${#tools[@]}" -gt 0 ]; then
    mise --yes install "${tools[@]}"
  fi
}

is_mac() {
  [[ "$OSTYPE" == "darwin"* ]]
}

is_codespaces() {
  [[ -n "$CODESPACES" ]]
}

link_file() {
  local src dst
  case "$1" in
    /*) src="$1" ;;
    *) src="$MODULE_DIR/$1" ;;
  esac
  src="$(readlink -f "$src")"
  if [ $? -ne 0 ]; then
    fail "could not find $1"
  fi
  dst="$2"

  if [ -e "$2" ]; then
    if [ "$src" = "$(readlink "$dst")" ]; then
      success "skipped $src"
      return 0
    else
      mv "$dst" "$dst.backup"
      success "moved $dst to $dst.backup"
    fi
  fi
  ln -sf "$src" "$dst"
  success "linked $src to $dst"
}

remote_bash_install() {
  if [ $# -lt 1 ]; then
    echo "Usage: remote-install <script-url> [args...]"
    return 1
  fi

  if ! check_command curl; then
    fail "Error: curl is not installed or not in PATH."
  fi

  local url="$1"
  shift

  # CI=true and SHELL=/bin/false are set to discourage installer scripts to
  # mess with shell config files
  curl -LsSf "$url" \
    | SHELL=/bin/false CI=true bash -s -- "$@"

  if [ $? -ne 0 ]; then
    fail "Error: Failed to execute the script from $url"
  fi
}

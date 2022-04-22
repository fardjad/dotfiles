pushd "$(dirname "$0")/.." > /dev/null
export DOTFILES=$(pwd -P)
popd > /dev/null

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
  exit
}

check_command() {
  command -v "$1" > /dev/null 2>&1
}

brew_install() {
  if ! brew ls --versions "$1" > /dev/null; then
    info "installing $1..."
    brew install "$1" || fail "error installing $1"
  else
    success "$1 is already installed"
  fi
}

brew_cask_install() {
  if ! brew ls --cask --versions "$1" > /dev/null 2>&1; then
    info "installing $1..."
    brew install --cask "$1" || fail "error installing $1"
  else
    success "$1 is already installed"
  fi
}

brew_tap() {
  if ! brew tap | grep -q "$1" > /dev/null; then
    info "tapping $1..."
    brew tap "$1" || fail "error tapping $1"
  else
    success "$1 is already tapped"
  fi
}

is_mac() {
  [[ "$OSTYPE" == "darwin"* ]]
}

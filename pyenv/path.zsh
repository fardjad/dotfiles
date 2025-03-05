export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$(brew --prefix)/opt/tcl-tk/bin:$PATH"

if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

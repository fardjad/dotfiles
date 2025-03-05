export STARSHIP_CONFIG="$HOME/.starship/config.toml"

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

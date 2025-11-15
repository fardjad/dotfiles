export EDITOR='nvim'

# JetBrains IDEs don't play nicely with my Neovim configuration
if [[ "$TERMINAL_EMULATOR" == JetBrains* ]]; then
  export EDITOR='vim'
fi

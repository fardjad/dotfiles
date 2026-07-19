if command -v opencode &> /dev/null && command -v tmux &> /dev/null; then
  opencode-tmux() {
    if [[ -z "$TMUX" ]]; then
      tmux new-session -s opencode 'opencode --port 4096'
    else
      opencode --port 4096
    fi
  }
fi

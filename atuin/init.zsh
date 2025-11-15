test -f "${HOME}/.atuin/bin/atuin" \
  && source "${HOME}/.atuin/bin/env" \
  && eval "$(atuin init zsh --disable-up-arrow)" \
  && eval "$(atuin gen-completions --shell zsh)"

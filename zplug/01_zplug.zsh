export ZPLUG_HOME="$HOME/.zplug"

if [ -n "$CODESPACES" ]; then
  LOCALE="en_US.UTF-8"
  export LC_CTYPE="$LOCALE"
  export LC_ALL="$LOCALE"
  export ZPLUG_HOME="$(brew --prefix)/opt/zplug"
fi

source "$ZPLUG_HOME/init.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "chriskempson/base16-shell", defer:1
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "plugins/sudo", from:oh-my-zsh
zplug "zdharma-continuum/fast-syntax-highlighting", defer:3

# FIXME
if [ -z "$CODESPACES" ]; then
  zplug "zpm-zsh/ls"
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

if ! zplug check; then
  zplug install
fi

zplug load

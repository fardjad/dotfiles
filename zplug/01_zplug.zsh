export ZPLUG_HOME="$HOME/.zplug"
source "$ZPLUG_HOME/init.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "chriskempson/base16-shell", defer:1
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "plugins/sudo", from:oh-my-zsh
zplug "sindresorhus/pure", defer:1
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "zpm-zsh/ls"
zplug "zsh-users/zsh-autosuggestions" # install the required Ruby version should rvm complain about that
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

if ! zplug check; then
  zplug install
fi

zplug load

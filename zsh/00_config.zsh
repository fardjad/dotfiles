export TERM="xterm-256color"

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=238"

export REPORTTIME=10

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt autocd
# share history between sessions
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# emacs mode
bindkey -e

# key bindings
# note: you can use sed -n l to figure out what escape sequences are sent to
# the terminal

# fuzzy find: start to type
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
bindkey "$terminfo[kcud1]" down-line-or-beginning-search
bindkey "$terminfo[cuu1]" up-line-or-beginning-search
bindkey "$terminfo[cud1]" down-line-or-beginning-search

# backward and forward word with ctrl/option+left/right
bindkey '^[^[[D' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[1;5C' forward-word

# to the beggining/end of line with fn+left/right or home/end
bindkey "${terminfo[khome]}" beginning-of-line
bindkey '^[[H' beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[F' end-of-line

# delete char with backspaces and delete
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# delete word with ctrl+backspace
bindkey '^[[3;5~' backward-delete-word

bindkey '^R' history-incremental-search-backward

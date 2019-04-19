[ -d /home/linuxbrew/.linuxbrew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

export PATH="$(brew --prefix)/sbin:$PATH"

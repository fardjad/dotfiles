<div id="header">

</div>

<div id="content">

<div class="sect1">

## Fardjad’s dotfiles

<div class="sectionbody">

<div class="sect2">

### Synopsis

<div class="paragraph">

This repository contains my no-frills [dotfiles](https://wiki.archlinux.org/title/Dotfiles). I use these dotfiles on the latest version of [macOS](https://www.apple.com/macos) and [Ubuntu on WSL](https://ubuntu.com/wsl).

</div>

<div class="paragraph">

It comes with an automated installer script and leverages [homebrew](https://brew.sh) to install packages on macOS and various Linux distributions.

</div>

</div>

<div class="sect2">

### Included Tools

<div id="header">

</div>

<div id="content">

<div id="preamble">

<div class="sectionbody">

<div class="ulist">

- [antidote](/antidote)

- [bash](/bash)

- [bat](/bat)

- [brew](/brew)

- [brew-cu](/brew-cu)

- [deno](/deno)

- [exa](/exa)

- [golang](/golang)

- [k8s](/k8s)

- [mcfly](/mcfly)

- [nodejs](/nodejs)

- [pyenv](/pyenv)

- [rbenv](/rbenv)

- [rust](/rust)

- [sdkman](/sdkman)

- [starship](/starship)

- [tldr](/tldr)

- [tmux](/tmux)

- [vim](/vim)

- [zsh](/zsh)

</div>

</div>

</div>

</div>

</div>

<div class="sect2">

### Installation

<div class="paragraph">

The following software packages are required to run the setup script.

</div>

| Dependency                                | Purpose                                                       |
| ----------------------------------------- | ------------------------------------------------------------- |
| [git](https://git-scm.com)                | Required for cloning this repository                          |
| [curl](https://curl.haxx.se)              | Used for downloading files from the web                       |
| [bash](https://www.gnu.org/software/bash) | Required for running the installer script                     |
| [brew](https://brew.sh)                   | Required for installing packages on macOS or Linux            |
| [sudo](https://www.sudo.ws)               | Required by the installer script to run some commands as root |

<div class="paragraph">

In order to install the dotfiles run the following command in a bash shell:

</div>

<div class="listingblock">

<div class="content">

```highlight
git clone https://github.com/fardjad/dotfiles.git ~/.dotfiles && ~/.dotfiles/script/setup
```

</div>

</div>

</div>

<div class="sect2">

### Updates

<div class="listingblock">

<div class="content">

```highlight
cd $DOTFILES
git pull origin master # make sure the working tree is clean before running this command
./script/setup
```

</div>

</div>

</div>

<div class="sect2">

### OS Specific Notes

<div class="ulist">

- (macOS only, optional) In order to set macOS defaults run the following:

</div>

<div class="listingblock">

<div class="content">

```highlight
[ -d ~/.dotfiles ] && ~/.dotfiles/macos/setup-macos.sh || echo >&2 'You must clone the repository first!'
```

</div>

</div>

<div class="ulist">

- (macOS only, optional) Configure iTerm2 to load preferences from `~/.dotfiles/macos/iterm2` directory.

- (macOS only, Apple Silicon) Run the following to enable Rosetta:

</div>

<div class="listingblock">

<div class="content">

```highlight
softwareupdate --install-rosetta
```

</div>

</div>

</div>

<div class="sect2">

### Credits

<div class="paragraph">

The directory structure of this repository is inspired by [carlos' dotfiles](https://github.com/caarlos0/dotfiles)

</div>

</div>

</div>

</div>

</div>

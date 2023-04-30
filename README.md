## Fardjad's dotfiles

### Synopsis

This repository contains my no-frills modular
[dotfiles](https://wiki.archlinux.org/title/Dotfiles).
I use these dotfiles on the latest version of
[macOS](https://www.apple.com/macos) and [Ubuntu on WSL](https://ubuntu.com/wsl).

It comes with an automated installer script and leverages
[homebrew](https://brew.sh) to install packages on macOS and various Linux
distributions.

### Installation

The following software packages are required to run the setup script.

| Dependency                                | Purpose                                                       |
| ----------------------------------------- | ------------------------------------------------------------- |
| [git](https://git-scm.com)                | Required for cloning this repository                          |
| [curl](https://curl.haxx.se)              | Used for downloading files from the web                       |
| [bash](https://www.gnu.org/software/bash) | Required for running the installer script                     |
| [brew](https://brew.sh)                   | Required for installing packages on macOS or Linux            |
| [sudo](https://www.sudo.ws)               | Required by the installer script to run some commands as root |

Make sure the dependencies are installed, and clone the repository:

```bash
git clone https://github.com/fardjad/dotfiles.git ~/.dotfiles
```

#### Install Everything

You can choose to install all of the tools by running the following command:

```bash
~/.dotfiles/script/setup
```

#### Install Individual Tools

If you don’t want to install everything, you can run the installer script of
each tool individually. For example, to install `nodejs`, you can run:

```bash
~/.dotfiles/nodejs/install.sh
```

Keep in mind that these dotfiles are designed to work with zsh, so it’s highly
recommended that you install zsh too:

```bash
~/.dotfiles/zsh/install.sh
```

Running the installer scripts multiple times is safe, and in most cases it will
update the installed packages to the latest version.

### OS Specific Notes

- (macOS only, optional) In order to set macOS defaults run the following:

```bash
[ -d ~/.dotfiles ] && ~/.dotfiles/macos/setup-macos.sh || echo >&2 'You must clone the repository first!'
```

- (macOS only, optional) Configure iTerm2 to load preferences from
  `~/.dotfiles/macos/iterm2` directory.
- (macOS only, Apple Silicon) Run the following to enable Rosetta:

```bash
softwareupdate --install-rosetta
```

### Credits

The directory structure of this repository is inspired by
[carlos' dotfiles](https://github.com/caarlos0/dotfiles)

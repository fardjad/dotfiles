# Use system pkg-config while still exposing Homebrew .pc files

if command -v brew > /dev/null 2>&1 \
  && [ -x /usr/bin/pkg-config ]; then

  BREW_PREFIX="$(brew --prefix 2> /dev/null)"
  BREW_PKG_CONFIG="$BREW_PREFIX/bin/pkg-config"

  if [ -x "$BREW_PKG_CONFIG" ]; then
    SYSTEM_PC_PATH="$(
      env -i /usr/bin/pkg-config --variable pc_path pkg-config
    )"

    BREW_PC_PATH="$BREW_PREFIX/lib/pkgconfig:$BREW_PREFIX/share/pkgconfig"

    export PKG_CONFIG=/usr/bin/pkg-config
    export PKG_CONFIG_PATH="$SYSTEM_PC_PATH:$BREW_PC_PATH"
  fi
fi

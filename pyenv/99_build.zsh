PYENV_LDFLAGS="-L$(brew --prefix)/opt/zlib/lib -L$(brew --prefix)/opt/bzip2/lib -L$(brew --prefix)/opt/openssl/lib"
PYENV_CPPFLAGS="-I$(brew --prefix)/opt/zlib/include -I$(brew --prefix)/opt/bzip2/include -I$(brew --prefix)/opt/openssl/include"

export LDFLAGS="$(echo $LDFLAGS | sed "s|$PYENV_LDFLAGS||g")"
export CPPFLAGS="$(echo $CPPFLAGS | sed "s|$PYENV_CPPFLAGS||g")"

TCL_TK_LD_FLAGS="-L$(brew --prefix)/opt/tcl-tk/lib"
TCL_TK_CPPFLAGS="-I$(brew --prefix)/opt/tcl-tk/include"
TCL_TK_PKG_CONFIG_PATH="$(brew --prefix)/opt/tcl-tk/lib/pkgconfig"

export LDFLAGS="$(echo $LDFLAGS | sed "s|$TCL_TK_LD_FLAGS||g")"
export CPPFLAGS="$(echo $CPPFLAGS | sed "s|$TCL_TK_CPPFLAGS||g")"
export PKG_CONFIG_PATH="$(echo $PKG_CONFIG_PATH | sed "s|$TCL_TK_PKG_CONFIG_PATH||g")"

export LDFLAGS="$PYENV_LDFLAGS $TCL_TK_LD_FLAGS $LDFLAGS"
export CPPFLAGS="$PYENV_CPPFLAGS $TCL_TK_CPPFLAGS $CPPFLAGS"

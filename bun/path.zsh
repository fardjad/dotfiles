# Store Bun global packages with the active mise-managed Bun version.
if command -v mise > /dev/null 2>&1; then
  _bun_install="$(mise where bun 2> /dev/null)"
  if [[ -n "$_bun_install" && -d "$_bun_install/bin" ]]; then
    export BUN_INSTALL="$_bun_install"
    export PATH="$BUN_INSTALL/bin:$PATH"
  fi
  unset _bun_install
fi

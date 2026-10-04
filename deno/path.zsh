# Store Deno global installs with the active mise-managed Deno version.
if command -v mise > /dev/null 2>&1; then
  _deno_install_root="$(mise where deno 2> /dev/null)"
  if [[ -n "$_deno_install_root" && -d "$_deno_install_root/bin" ]]; then
    export DENO_INSTALL_ROOT="$_deno_install_root"
    export PATH="$DENO_INSTALL_ROOT/bin:$PATH"
  fi
  unset _deno_install_root
fi

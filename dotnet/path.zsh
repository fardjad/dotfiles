export DOTNET_INSTALL_DIR="${HOME}/.dotnet"
test -d "${DOTNET_INSTALL_DIR}" && export PATH="${DOTNET_INSTALL_DIR}:$PATH"

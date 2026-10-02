if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

for tool_path_config in "${DOTFILES:?}"/{bun,deno}/path.zsh(N); do
  source "$tool_path_config"
done
unset tool_path_config

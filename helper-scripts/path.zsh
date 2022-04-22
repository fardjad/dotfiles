BASE_DIR="$HOME/.helper-scripts"

[ -d "$BASE_DIR" ] && for d in "$BASE_DIR"/*; do
  export PATH="$d:$PATH"
done

export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"
nvs auto on
[ -f .nvmrc ] && nvs use
[ -f .node-version ] && nvs use

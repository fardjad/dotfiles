should_install=0
connected=0

if ! command -v "socket" > /dev/null 2>&1 && command -v "npm" > /dev/null && [ $connected -eq 1 ]; then
  should_install=1
fi

if [ $should_install -eq 1 ] && ping -q -c 1 -W 1 npmjs.com > /dev/null; then
  connected=1
fi

if [ $should_install -eq 1 ] && [ $connected -eq 1 ]; then
  npm install -g @socketsecurity/cli
fi

unset should_install
unset connected

alias npm="socket npm"
alias npx="socket npx"

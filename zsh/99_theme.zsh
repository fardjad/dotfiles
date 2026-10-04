if command -v base16_eighties > /dev/null 2>&1; then
  base16_eighties
fi

if command -v fast-theme > /dev/null 2>&1; then
  fast-theme -q HOME:overlay
fi

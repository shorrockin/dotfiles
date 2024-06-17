# on linux, use batcat instead of bat
[[ ! -f /usr/bin/batcat ]] || alias bat='batcat'

if command -v bat &> /dev/null; then
  alias cat='bat'
  alias more='bat'
fi

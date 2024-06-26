# alias ls to eza, which is a nicer ls. 
# https://github.com/eza-community/eza
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=always"
  alias llt='ls --long --tree --level=3'
  alias lst='ls --long --tree --level=3'
fi


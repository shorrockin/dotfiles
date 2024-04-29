# https://github.com/ajeetdsouza/zoxide
# auto-completing cd, using space-tab, with memories
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd=z
fi



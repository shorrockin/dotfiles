# Minimal Zsh prompt for emergency use
# Format: [user@host:path]$
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%F{blue}[%n@%m:%~]%f$ '

# Set up FZF environment variables for better integration

# Use fd for finding files if available (faster and respects .gitignore)
if type -q fd
    set -gx FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
end

# Add preview capabilities with bat if available
if type -q bat
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
end

# General FZF options
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline --marker=+ --prompt='❯ '"

# If using a catppuccin theme for consistency
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
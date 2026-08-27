# common shared config

NixOS, macOS, and Omarchy stow this directory before their platform root. Generic Linux gets the entries linked from `linux/`.

## Directory contents

- `dots/`: shared home-directory dotfiles, stowed via `--dotfiles` (dot-X → .X; already-dotted files like `.gitignore` stow as-is): `dot-gitconfig`, `dot-personal.gitconfig`, `.gitignore`, `dot-ideavimrc`, `dot-vimrc`, `dot-tigrc`
- `config/`: shared app configs → `~/.config/`: `assets/` (wallpapers/logos/avatars), `bat/`, `btop/`, `delta/`, `fish/`, `ghostty/`, `herdr/`, `lazygit/`, `nvim/`, `oh-my-posh/`, `tmux/`, `tuicr/`, `vivaldi/`, `zsh/`
  - `scripts/`: platform-agnostic utilities, including the `dots` wrapper and `dots-check`. Platform-specific scripts live under that platform's own `config/scripts/` instead (e.g. `../nixos/config/scripts/`) — nothing here assumes `hyprctl`, `yabai`, `osascript`, etc.

## Neovim

`dots` pre-creates `~/.config/nvim/{lua,lua/lsp,lua/plugins}` and `~/.config/nvim/after/{plugin,ftplugin}` before stowing, on every platform, so symlinked public config can coexist with private/local files that aren't in the repo. New Neovim directories need to fit this partial-stow approach — don't symlink `~/.config/nvim` wholesale.

## Shell

Fish everywhere (`config/fish/`), oh-my-posh for the prompt. Env vars live in `config/fish/conf.d/`. `config/zsh/` ships shared snippets (aliases, git, fzf) including an `osx.sh` that's internally macOS-conditional but harmless elsewhere.

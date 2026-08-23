# common/ — Shared Across Every Platform

Ships identically on NixOS, macOS, and Omarchy — the `common` stow root is
always applied first, before whichever platform root matches the current
machine (see repo root `CLAUDE.md` for the stow mechanics).

## Directory Contents

- `dots/`: shared home-directory dotfiles, stowed via `--dotfiles` (dot-X → .X,
  already-dotted files like `.gitignore` are stowed as-is): `dot-gitconfig`,
  `dot-personal.gitconfig`, `.gitignore`, `dot-ideavimrc`, `dot-vimrc`, `dot-tigrc`
  - `dot-agents/` → `~/.agents`, `dot-claude/` → `~/.claude`: personal
    cross-tool agent config (instructions + skills), independent of any
    project's own CLAUDE.md/AGENTS.md — see `../CLAUDE.md`'s Shared Agent
    Config note for the symlink structure between the two.
- `config/`: shared app configs, symlinked to `~/.config/`:
  `assets/` (wallpapers/logos/avatars), `bat/`, `btop/`, `delta/`, `fish/`,
  `ghostty/`, `herdr/`, `lazygit/`, `nvim/`, `oh-my-posh/`, `tmux/`, `tuicr/`,
  `vivaldi/`, `zsh/`
  - `scripts/`: platform-agnostic utility scripts, incl. the `dots` wrapper
    itself and `dots-check`. Scripts that only make sense on one platform
    live under that platform's own `config/scripts/` instead (e.g.
    `../nixos/config/scripts/`, `../macos/config/scripts/`) — nothing here
    should assume `hyprctl`, `yabai`, `osascript`, etc. are present.

## Neovim Configuration Strategy

`common/config/scripts/dots` pre-creates `~/.config/nvim/{lua,lua/lsp,lua/plugins}`
and `~/.config/nvim/after/{plugin,ftplugin}` *before* stowing, on every platform.

- **Why**: this allows mixing symlinked public config with private/local files
  that aren't in the repo, across different environments and operating systems
- **Implication**: when adding new Neovim directories, ensure they're
  compatible with this "partial stow" approach — don't symlink `~/.config/nvim`
  wholesale.

## Shell

Fish is the primary shell everywhere (`config/fish/`), with oh-my-posh for
the prompt (`config/oh-my-posh/`). Environment variables live in
`config/fish/conf.d/`. `config/zsh/` ships shared shell snippets (aliases,
git, fzf, etc.) — including an `osx.sh` file that's internally
macOS-conditional but harmless to have present elsewhere.

## Editor

Neovim with Lazy.nvim — see `config/nvim/init.lua`, `config/nvim/lua/`.
LSP config: `config/nvim/lua/plugins/lsp.lua`.

# common/ — shared across every platform

Ships identically on NixOS, macOS, and Omarchy — `common` stows first, before whichever platform root matches the machine (see repo root CLAUDE.md).

## Directory contents

- `dots/`: shared home-directory dotfiles, stowed via `--dotfiles` (dot-X → .X; already-dotted files like `.gitignore` stow as-is): `dot-gitconfig`, `dot-personal.gitconfig`, `.gitignore`, `dot-ideavimrc`, `dot-vimrc`, `dot-tigrc`
  - `dot-agents/` → `~/.agents`, `dot-claude/` → `~/.claude`: personal cross-tool agent config — see below.
- `config/`: shared app configs → `~/.config/`: `assets/` (wallpapers/logos/avatars), `bat/`, `btop/`, `delta/`, `fish/`, `ghostty/`, `herdr/`, `lazygit/`, `nvim/`, `oh-my-posh/`, `tmux/`, `tuicr/`, `vivaldi/`, `zsh/`
  - `scripts/`: platform-agnostic utilities, including the `dots` wrapper and `dots-check`. Platform-specific scripts live under that platform's own `config/scripts/` instead (e.g. `../nixos/config/scripts/`) — nothing here assumes `hyprctl`, `yabai`, `osascript`, etc.

## Neovim

`dots` pre-creates `~/.config/nvim/{lua,lua/lsp,lua/plugins}` and `~/.config/nvim/after/{plugin,ftplugin}` before stowing, on every platform, so symlinked public config can coexist with private/local files that aren't in the repo. New Neovim directories need to fit this partial-stow approach — don't symlink `~/.config/nvim` wholesale.

## Shell

Fish everywhere (`config/fish/`), oh-my-posh for the prompt. Env vars live in `config/fish/conf.d/`. `config/zsh/` ships shared snippets (aliases, git, fzf) including an `osx.sh` that's internally macOS-conditional but harmless elsewhere.

## Shared agent config (`~/.agents`, `~/.claude`)

Personal cross-tool agent config, independent of any project's own CLAUDE.md/AGENTS.md. `dot-agents/` holds the real `AGENTS.md` and `skills/<name>/` directories. `dot-claude/` holds only symlinks: `CLAUDE.md` → `../dot-agents/AGENTS.md`, and one `skills/<name>` → `../../dot-agents/skills/<name>` per skill. Paths are relative to the symlink's own location in the repo (stow adds one hop, it doesn't relocate the file) — a `../.agents/...`-style path from `dot-claude/` would resolve wrong.

`~/.claude/skills/` is a real, pre-populated directory (Omarchy symlinks its own skills into it) — stow can't fold a directory-level `skills` symlink into it (crashes stow's unstow phase: `unstow_contents() called with non-directory path`). Hence per-skill symlinks instead.

**Adding a personal skill takes two steps:** create it under `dot-agents/skills/<name>/`, then `ln -s ../../dot-agents/skills/<name> dot-claude/skills/<name>` and restow — it won't show up in Claude Code until that second symlink exists.

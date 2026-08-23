# CLAUDE.md

Guidance for Claude Code when working in this repo.

## Layout

Cross-platform dotfiles for NixOS, macOS, and Omarchy (Arch + Hyprland), managed with GNU Stow. A directory's location determines what ships where — not an ignore-list.

```
~/dotfiles/
├── common/     # ships everywhere — dots/ (→ ~) and config/ (→ ~/.config)
├── nixos/      # NixOS only: flake.nix, hosts/, modules/, home/, config/
├── macos/      # macOS only: dots/, config/
└── omarchy/    # Omarchy only: install.sh, install.d/, config/, hosts/<hostname>/
```

Every platform root that has home-directory or `~/.config` content uses the same two stow package names, `dots` and `config`. `common/config/scripts/dots` (the stow wrapper) always stows `common/` first, then whichever platform root matches the current machine (detected via `$OSTYPE` and the presence of `/usr/share/omarchy`).

Platform details: [common](common/CLAUDE.md), [nixos](nixos/CLAUDE.md), [macos](macos/CLAUDE.md), [omarchy](omarchy/CLAUDE.md).

## Commands

```bash
common/config/scripts/dots stow     # symlink everything for this platform
common/config/scripts/dots restow   # re-link after changes
common/config/scripts/dots delete   # remove all symlinks
```

NixOS rebuilds are in `nixos/CLAUDE.md`; Omarchy bootstrap is in `omarchy/CLAUDE.md`.

## Symlinks

Files under `~/.config` and `~` are symlinks into this repo — editing through either location edits the repo directly, no re-stow needed.

Stowing multiple roots into the same target (e.g. `common/config/` and `nixos/config/` both into `~/.config/`) is safe: each `~/.config` subdirectory is owned by exactly one root, except `~/.config/scripts/`, a real directory that multiple roots plant individual file symlinks into.

If a machine's platform ever changes (e.g. Omarchy → NixOS), run `dots delete` on the old checkout first — a plain restow won't clean up the old root's symlinks.

`dots` backs up any real pre-existing file it would conflict with to `*.pre-stow-backup.<timestamp>` before stowing — it never deletes.

## Conventions

- Shell script shebangs: always `#!/usr/bin/env bash`, never `#!/bin/bash` — NixOS has no `/bin/bash`.
- Personal cross-tool agent config (`~/.agents`, `~/.claude`) is documented in `common/CLAUDE.md`.

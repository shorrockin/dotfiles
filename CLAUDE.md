# CLAUDE.md

Guidance for Claude Code when working in this repo.

## Layout

Cross-platform dotfiles for Linux, NixOS, macOS, and Omarchy, managed with GNU Stow. Directory location determines where each file ships.

```
~/dotfiles/
├── common/     # shared config source
├── linux/      # selected common config for headless Linux
├── nixos/      # NixOS only: flake.nix, hosts/, modules/, home/, config/
├── macos/      # macOS only: dots/, config/
└── omarchy/    # Omarchy only: install.sh, install.d/, config/, hosts/<hostname>/
```

Each stow root uses `dots` for home-directory files and `config` for `~/.config`. The `dots` wrapper stows `common` plus the detected macOS, NixOS, or Omarchy root. On generic Linux it stows `linux`, whose entries link to the selected files in `common`.

Platform details: [common](common/CLAUDE.md), [linux](linux/CLAUDE.md), [nixos](nixos/CLAUDE.md), [macos](macos/CLAUDE.md), [omarchy](omarchy/CLAUDE.md).

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
- Personal cross-tool agent config (`~/.agents`, `~/.claude`) is platform-owned. Document it in the owning platform's `CLAUDE.md`; platforms without those entries do not install it.

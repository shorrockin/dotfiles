# AGENTS.md

Instructions for coding agents working in this repo.

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

Platform details: [common](common/AGENTS.md), [linux](linux/AGENTS.md), [nixos](nixos/AGENTS.md), [macos](macos/AGENTS.md), [omarchy](omarchy/AGENTS.md).

## Commands

```bash
common/config/scripts/dots stow     # symlink everything for this platform
common/config/scripts/dots restow   # re-link after changes
common/config/scripts/dots delete   # remove all symlinks
```

See the NixOS platform instructions for rebuilds and the Omarchy platform instructions for bootstrap details.

## Symlinks

Files under `~/.config` and `~` are symlinks into this repo — editing through either location edits the repo directly, no re-stow needed.

Stowing multiple roots into the same target (e.g. `common/config/` and `nixos/config/` both into `~/.config/`) is safe: each `~/.config` subdirectory is owned by exactly one root, except `~/.config/scripts/`, a real directory that multiple roots plant individual file symlinks into.

If a machine's platform ever changes (e.g. Omarchy → NixOS), run `dots delete` on the old checkout first — a plain restow won't clean up the old root's symlinks.

`dots` backs up any real pre-existing file it would conflict with to `*.pre-stow-backup.<timestamp>` before stowing — it never deletes.

## Conventions

- Shell script shebangs: always `#!/usr/bin/env bash`, never `#!/bin/bash` — NixOS has no `/bin/bash`.
- Personal cross-tool agent config (`~/.agents`, `~/.claude`) is platform-owned. Document it in the owning platform's instructions; platforms without those entries do not install it.
- When a directory needs scoped agent instructions, put the canonical content in `AGENTS.md` and add a relative `CLAUDE.md` symlink to it. Never create the singular `AGENT.md`. In prose, refer to "repository instructions" or "directory instructions" instead of naming a tool-specific compatibility file.

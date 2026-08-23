# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Table of Contents

- [Repository Overview](#repository-overview)
- [Platform-First Directory Layout](#platform-first-directory-layout)
- [Common Commands](#common-commands)
- [Symlink Management](#symlink-management)
- [Git Integration](#git-integration)
- [Development Conventions](#development-conventions)
- [Platform-Specific Docs](#platform-specific-docs)

## Repository Overview

This is a **cross-platform dotfiles repository** for NixOS, macOS, and
Omarchy (Arch + Hyprland), managed with GNU Stow. The directory structure
itself is the source of truth for what belongs to which platform — see
below — rather than that being encoded in ignore-lists inside a script.

The repository assumes it's cloned to `~/dotfiles`.

## Platform-First Directory Layout

```
~/dotfiles/
├── common/     # ships on every platform — dots/ (→ ~) and config/ (→ ~/.config)
├── nixos/      # NixOS-only: flake.nix, hosts/, modules/, home/ (Home Manager), config/
├── macos/      # macOS-only: dots/, config/
└── omarchy/    # Omarchy-only: install.sh, install.d/, config/, hosts/<hostname>/
```

Every platform directory that has home-directory dotfiles or `~/.config`
content uses the exact same two stow package names — `dots` and `config` —
stowed from that root. `common/config/scripts/dots` (the stow wrapper)
always stows `common/` first, then whichever platform root matches the
current machine (detected via `$OSTYPE` and the presence of
`/usr/share/omarchy`). This means a directory's *location* in the repo is
what determines whether it ships on a given machine — nothing else decides
this, and there are no per-directory ignore-lists to keep in sync.

See each platform directory's own `CLAUDE.md` for what it actually contains
and platform-specific setup/notes — [Platform-Specific Docs](#platform-specific-docs) below.

## Common Commands

**Initial setup — symlinks everything applicable to this platform:**
```bash
common/config/scripts/dots stow
```

**Re-link dotfiles (useful after changes):**
```bash
common/config/scripts/dots restow
```

**Remove all symlinks:**
```bash
common/config/scripts/dots delete
```

**Validation:**
```bash
# Check which files in ~/.config/ are symlinks to dotfiles repo
ls -la ~/.config/ | grep "\->"

# Verify a specific symlink target
readlink ~/.config/fish/config.fish
# Should return: /home/username/dotfiles/common/config/fish/config.fish (or nixos/macos/omarchy, depending)

# Check for stow conflicts (dry run before actual stow)
stow -n --dir=~/dotfiles/common --target=~/.config config
```

For NixOS-specific commands (rebuild, flake update, Home Manager) see
`nixos/CLAUDE.md`. For Omarchy bootstrap see `omarchy/CLAUDE.md`.

## Symlink Management

**Critical Understanding**: `common/config/scripts/dots` creates **symbolic
links** from this repository into your home directory — `<root>/dots/dot-X`
→ `~/.X`, `<root>/config/Y` → `~/.config/Y` — for `<root>` = `common` and
whichever platform root applies.

This means:
- Changes made to files in this repo are **immediately reflected** at their
  symlink target — no "re-install" needed after editing.
- If you modify a file through `~/.config/` or `~`, you're actually editing
  the file in this repo.
- Running `dots stow`/`restow` on multiple roots into the same target
  (e.g. `common/config/` and `nixos/config/` both symlinking into
  `~/.config/`) is safe: stow's bookkeeping is derived by walking the target
  and resolving existing symlinks, not by keeping cross-invocation state, and
  by construction each `~/.config` subdirectory is owned by exactly one root.
  The one deliberately multi-root case is `~/.config/scripts/`, a real
  pre-created directory that multiple roots plant individual file-level
  symlinks into.
- **Platform-switch caveat**: if a machine's detected platform ever changes
  (e.g. a box reprovisioned from Omarchy to NixOS), symlinks from the old
  platform root won't be cleaned up by a plain `stow`/`restow` — run
  `dots delete` on the old checkout first, or manually prune dangling links.

`dots` also handles the "fresh install already has real stock config files"
problem: before each stow, it dry-runs and moves any pre-existing real
file/dir that would conflict aside to `*.pre-stow-backup.<timestamp>` —
never deletes, so nothing is lost.

## Git Integration

- Standard git workflows for dotfile changes
- Multiple gitconfig files for personal/work separation (`common/dots/dot-gitconfig`, `dot-personal.gitconfig`)
- Delta configured for enhanced git diffs (`common/config/delta/`)
- NixOS system changes via `nix flake update` and manual `nixos-rebuild` (user-initiated only — see `nixos/CLAUDE.md`)

## Development Conventions

### Shell Script Shebangs
**Always use `#!/usr/bin/env bash`** (not `#!/bin/bash`) when creating or
modifying shell scripts. NixOS does not have `/bin/bash`, so hardcoded paths
will fail.

### Shared Agent Config (`~/.agents`, `~/.claude`)

Separate from this repo's own `CLAUDE.md`/`AGENT.md` files — `common/dots/dot-agents/`
(→ `~/.agents`, contains `AGENTS.md` + a `skills/` directory for future use)
and `common/dots/dot-claude/` (→ `~/.claude`, contains only `CLAUDE.md`) are
personal cross-tool agent configuration deployed to every machine via the
normal `common/dots/` stow mechanism.

`dot-claude/CLAUDE.md` is a symlink to `../dot-agents/AGENTS.md` — i.e. it
points at the sibling package's file *within the repo*, not at `~/.agents/AGENTS.md`
directly. This matters: a relative symlink committed as stow package content
resolves relative to its own on-disk location in the repo (stow only adds
one symlink hop from the target into the repo; it never copies or relocates
the file), so a target-relative path like `../.agents/AGENTS.md` would
resolve relative to `common/dots/dot-claude/` and land on a nonexistent
`common/dots/.agents/AGENTS.md` — exactly the bug this had until it was
caught live. Pointing at the sibling package's real file instead means both
`~/.claude/CLAUDE.md` and `~/.agents/AGENTS.md` independently resolve (via
their own stow-created hop) to the same real file.

**Skills are intentionally *not* symlinked between the two yet.**
`~/.claude/skills/` already exists as a real, populated directory on a live
Claude Code install (on Omarchy it's individual per-skill symlinks to
`/usr/share/omarchy/default/agents/skills/...`) — stow can't safely fold a
directory-level `skills` symlink into an already-real directory it doesn't
own (confirmed the hard way: it crashes stow's unstow phase with
`unstow_contents() called with non-directory path`, mid-restow, on a live
machine). Sharing skills between `~/.claude` and `~/.agents` needs either
per-skill symlinks (enumerated individually, `--adopt`, or handled outside
stow) or some other mechanism — left as a deliberate follow-up, not attempted
here.

## Platform-Specific Docs

- [`common/CLAUDE.md`](common/CLAUDE.md) — shared config, Neovim strategy, scripts convention
- [`nixos/CLAUDE.md`](nixos/CLAUDE.md) — flake/modules/Home Manager, rebuild commands, package management patterns
- [`macos/CLAUDE.md`](macos/CLAUDE.md) — Aerospace/yabai/skhd
- [`omarchy/CLAUDE.md`](omarchy/CLAUDE.md) — bootstrap (`install.sh`/`install.d/`), host profiles, udev rule, hypr overrides

# omarchy/ — Omarchy platform notes

[Omarchy](https://omarchy.org/) is Arch Linux + Hyprland with its own config layer (Lua Hyprland config, Quickshell bar/launcher/notifications, its own theme system). This repo doesn't port the NixOS raw-Hyprland stack (`../nixos/config/`) onto it — Omarchy already owns that layer, and fighting it causes conflicts (duplicate bars, stale Lua vs. conf-format Hyprland config).

## Directory contents

- `install.sh`: orchestrator — runs each `install.d/*.sh` in order.
- `install.d/`: bootstrap steps, each idempotent, reading `$DOTFILES_DIR`:
  - `00-packages.sh`, `10-shell.sh` (sets fish as default), `20-stow.sh`, `30-tmux-plugins.sh` (tpm)
  - `40-hypr-overrides.sh` — wires `require("hypr.overrides")` into the live `~/.config/hypr/hyprland.lua`, validates via `hyprctl` if running
  - `50-host-setup.sh` — runs `hosts/$(hostname)/setup.d/*.sh`, if present, in order
- `config/`: Omarchy-only `~/.config` overlay. Currently just `hypr/overrides.lua`, a hook Omarchy's `hyprland.lua` loads (see below).
- `hosts/<hostname>/`: per-machine setup (mirrors NixOS's `hosts/<name>.nix`), can have `setup.d/`, `udev/`, `config/`. See [`hosts/gustave/CLAUDE.md`](hosts/gustave/CLAUDE.md) for that host's specifics.
- `backgrounds/catppuccin/`: wallpapers

## Bootstrap a new box

```bash
omarchy/install.sh
```

Safe to re-run.

Two config-level fixes apply on every platform, not just Omarchy:
- tmux prefers `~/.config/tmux/tmux.conf` (XDG) over legacy `~/.tmux.conf`, so the repo's tmux config lives at `common/config/tmux/tmux.conf` rather than a `dot-tmux.conf` dotfile.
- `chsh` only affects new login sessions. `common/config/ghostty/config` sets `command = fish` so new terminal windows use fish immediately, without a logout.

## What `common/config/scripts/dots` does here

Same pre-existing-file backup behavior as elsewhere (see repo root CLAUDE.md), then stows `common/` → `omarchy/` → `hosts/<hostname>/config/` if present. The entire `nixos/` root (`hypr`, `hyprpanel`, `waybar`, etc.) is never part of the `omarchy` platform root and never gets stowed here — Omarchy's own Quickshell shell and Lua Hyprland config replace those.

## Hypr overrides

Omarchy's `hyprland.lua` loads user files after its own defaults (`require("hypr.bindings")`, etc.) — those stay local/untracked, using Omarchy's defaults as-is. Only `config/hypr/overrides.lua` (→ `~/.config/hypr/overrides.lua`) is tracked, loaded via one appended `require("hypr.overrides")` line.

## No Alacritty

Removed from the repo on all platforms — Ghostty is the terminal everywhere now.

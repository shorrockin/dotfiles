# omarchy/ — Omarchy platform notes

[Omarchy](https://omarchy.org/) is Arch Linux + Hyprland with its own config layer (Lua Hyprland config, Quickshell bar/launcher/notifications, its own theme system). This repo doesn't port the NixOS raw-Hyprland stack (`../nixos/config/`) onto it — Omarchy already owns that layer, and fighting it causes conflicts (duplicate bars, stale Lua vs. conf-format Hyprland config).

## Directory contents

- `install.sh`: orchestrator — runs each `install.d/*.sh` in order.
- `install.d/`: bootstrap steps, each idempotent, reading `$DOTFILES_DIR`:
  - `00-packages.sh` (including `hypridle` for one-hour idle suspend), `10-shell.sh` (sets fish as default), `20-stow.sh`, `30-tmux-plugins.sh` (tpm)
  - `40-hypr-overrides.sh` — wires `require("hypr.overrides")` into the live `~/.config/hypr/hyprland.lua`, validates via `hyprctl` if running
  - `45-nas-mount.sh`, `46-nautilus-nas-bookmark.sh` — configures the Synology share used by both desktops
  - `47-disable-locking.sh` — keeps both desktop sessions password-free while leaving the screensaver enabled
  - `48-enable-idle-suspend.sh` — enables `hypridle` for suspend after one hour of inactivity
  - `50-host-setup.sh` — runs `hosts/$(hostname)/setup.d/*.sh`, if present, in order
- `dots/`: Omarchy-only home files, including personal cross-tool agent config and `dot-tmux-sessionizer.conf`
- `config/`: Omarchy-only `~/.config` overlay. `hypr/overrides.lua` is loaded by
  Omarchy's `hyprland.lua`; `hypr/hypridle.conf` suspends after one hour idle.
- `hosts/<hostname>/`: per-machine setup (mirrors NixOS's `hosts/<name>.nix`), can have `setup.d/`, `udev/`, `config/`. Current profiles: [`gustave`](hosts/gustave/AGENTS.md) and [`maelle`](hosts/maelle/AGENTS.md).
- `backgrounds/catppuccin/`: wallpapers

## Bootstrap a new box

```bash
omarchy/install.sh
```

Safe to re-run. Host overlays use the exact output of `hostname`, so set the
machine hostname before running the installer. A machine named `maelle`, for
example, loads `hosts/maelle/`.

Two config-level fixes apply on every platform, not just Omarchy:
- The canonical tmux config lives at `common/config/tmux/tmux.conf` and tmux loads it from `~/.config/tmux/tmux.conf`.
- `chsh` only affects new login sessions. `common/config/ghostty/config` sets `command = fish` so new terminal windows use fish immediately, without a logout.

Both Omarchy host profiles, `gustave` and `maelle`, inherit the shared
one-hour idle-suspend policy from `config/hypr/hypridle.conf` and
`install.d/48-enable-idle-suspend.sh`.

## What `common/config/scripts/dots` does here

Same pre-existing-file backup behavior as described in the repository instructions, then stows `common/` → `omarchy/` → `hosts/<hostname>/config/` if present. The entire `nixos/` root (`hypr`, `hyprpanel`, `waybar`, etc.) is never part of the `omarchy` platform root and never gets stowed here — Omarchy's own Quickshell shell and Lua Hyprland config replace those.

## Personal agent config

`dots/dot-agents/` owns the canonical agent instructions and `skills/<name>/` directories. `dots/dot-claude/` contains compatibility links for tools that use that location. Keep the links relative to their locations in the repo because Stow adds one path hop without relocating the source.

`~/.claude/skills/` is a real, pre-populated directory, so each skill needs its own link. To add one, create `dots/dot-agents/skills/<name>/`, then run `ln -s ../../dot-agents/skills/<name> dots/dot-claude/skills/<name>` and restow.

## Hypr overrides

Omarchy's `hyprland.lua` loads user files after its own defaults (`require("hypr.bindings")`, etc.) — those stay local/untracked, using Omarchy's defaults as-is. Only `config/hypr/overrides.lua` (→ `~/.config/hypr/overrides.lua`) is tracked, loaded via one appended `require("hypr.overrides")` line.

The shared override loads `~/.config/hypr/host.lua` when a host profile supplies
one. Keep rules used by every Omarchy machine in `overrides.lua`; put keyboard,
application, or other machine-specific bindings in the host file.

## No Alacritty

Removed from the repo on all platforms — Ghostty is the terminal everywhere now.

# omarchy/ — Omarchy Platform Notes

[Omarchy](https://omarchy.org/) is Arch Linux + Hyprland with its own opinionated
config layer (Lua-based Hyprland config, a Quickshell-based bar/launcher/notification
shell, its own theme system). This repo treats it as a third platform alongside
NixOS and macOS, but deliberately does **not** try to port the NixOS raw-Hyprland
stack (`../nixos/config/`) onto it — Omarchy already owns that layer, and fighting
it causes conflicts (duplicate bars, stale Lua vs. conf-format Hyprland config, etc).

## Directory Contents

- `install.sh`: thin orchestrator — loops over `install.d/*.sh` in order and
  runs each. Look at that directory's listing to see everything bootstrap does.
- `install.d/`: one script per bootstrap step, each idempotent and reading
  `$DOTFILES_DIR` from the environment (exported by `install.sh`):
  - `00-packages.sh` — installs missing packages (`fish`, `git-delta`, `stow`, `ttf-meslo-nerd`, etc.)
  - `10-shell.sh` — sets fish as the default shell
  - `20-stow.sh` — runs `common/config/scripts/dots stow`
  - `30-tmux-plugins.sh` — installs tmux's plugin manager (tpm) and its plugins
  - `40-steam-controller-udev.sh` — installs the Steam controller udev rule + `input` group membership
  - `50-hypr-overrides.sh` — wires `require("hypr.overrides")` into the live `~/.config/hypr/hyprland.lua`, validates via `hyprctl` if running
  - `60-host-setup.sh` — runs every script in `hosts/$(hostname)/setup.d/`, if present, in order
- `config/`: Omarchy-only `~/.config` overlay, stowed as the `omarchy` platform
  root. Currently just `hypr/overrides.lua` — a hook Omarchy's own
  `hyprland.lua` loads (see below), not a full config replacement.
- `hosts/<hostname>/`: per-machine setup, mirroring NixOS's `hosts/<name>.nix`
  pattern. Each host directory can have a `setup.d/` (numbered scripts, same
  convention as the top-level `install.d/`, run in order by
  `install.d/60-host-setup.sh` only when the current hostname matches) and,
  if ever needed, a `config/` subfolder (stowed after `omarchy/config/`, so
  it can override individual files for that one machine). Today: `gustave/`
  only —`setup.d/10-nvidia-hibernate.sh` (NVIDIA hibernate/suspend systemd
  units), `setup.d/20-nas-mount.sh` (Synology NAS CIFS mount, see below), and
  `setup.d/30-nautilus-nas-bookmark.sh` (sidebar bookmark for that mount).
- `udev/99-uinput-steam-controller.rules`: static udev rule (see below)
- `backgrounds/catppuccin/`: wallpapers

## Bootstrap a new Omarchy box

```bash
omarchy/install.sh
```

Safe to re-run — every step in `install.d/` checks current state first.

Two gotchas this uncovered on first run, fixed at the config level (not
Omarchy-specific, apply on every platform):
- tmux prefers `~/.config/tmux/tmux.conf` (XDG) over legacy `~/.tmux.conf` —
  the repo's tmux config lives at `common/config/tmux/tmux.conf` instead of
  a `dot-tmux.conf` dotfile, so it isn't shadowed by a stock XDG file.
- `chsh` only takes effect for a *new* login session — a graphical session
  already running keeps its original `$SHELL`. `common/config/ghostty/config`
  sets `command = fish` explicitly so new terminal windows are correct
  immediately, without needing a logout.

## Steam controller udev rule

Arch's `steam-devices` package grants `/dev/uinput` access via a dynamic
`uaccess` ACL tied to the logind seat session, which doesn't reliably apply
in time for Steam's controller "Desktop Configuration" virtual-gamepad
emulation. `udev/99-uinput-steam-controller.rules` is a static fallback
(permanent `input` group ownership, mode 0660) that
`install.d/40-steam-controller-udev.sh` copies to `/etc/udev/rules.d/`,
reloading udev and adding the user to the `input` group as needed.

## What `common/config/scripts/dots` does on Omarchy

`dots` itself handles the "fresh Omarchy install already has real stock config
files" problem: before each stow, it dry-runs and moves any pre-existing real
file/dir that would conflict (Omarchy's stock LazyVim starter at
`~/.config/nvim`, stock `btop.conf`, `ghostty/config`, etc.) aside to
`*.pre-stow-backup.<timestamp>` — never deletes, so nothing is lost. See the
repo root `CLAUDE.md` for the general stow mechanics; on Omarchy specifically,
`dots` stows `common/` then `omarchy/` then, if present, this machine's
`hosts/<hostname>/config/` overlay.

**What's excluded on Omarchy**: the entire `nixos/` root — `hypr`, `hyprpanel`,
`waybar`, `swaync`, `wlogout`, `rofi`, `walker`, `vicinae`, `quickshell`,
`fastfetch` never get stowed here, because they're simply never part of the
`omarchy` platform root. Omarchy's own Quickshell shell, Lua Hyprland config,
and `voxtype` dictation replace the NixOS-side equivalents.

## Hypr overrides

Omarchy's `hyprland.lua` already loads user files after its own defaults
(`require("hypr.bindings")`, `require("hypr.monitors")`, etc.) — those six
files stay local/untracked on purpose, using Omarchy's defaults as-is. The
only tracked file is `config/hypr/overrides.lua` (stowed to
`~/.config/hypr/overrides.lua`), loaded via one appended
`require("hypr.overrides")` line — a small hook for future tweaks without
adopting Omarchy's whole config into git.

## Synology NAS mount (gustave)

`hosts/gustave/setup.d/20-nas-mount.sh` adds a CIFS mount of the Synology at
`192.168.7.107` (`//192.168.7.107/Upload` → `/mnt/nas`) via `/etc/fstab`,
using `x-systemd.automount,noauto,nofail,_netdev` so it mounts lazily on
first access rather than blocking boot if the NAS is offline. This mirrors
the mount this machine had when it ran NixOS (`nixos/modules/synology.nix`,
now stale since gustave moved to Omarchy — that file isn't applied here).

Credentials are **not** committed to the repo. The script creates a
placeholder at `/etc/samba/smb-secrets` (root-only, mode 600) with empty
`username=`/`password=` lines, and — only the first time it creates either
the credentials file or the `fstab` entry — prints the exact follow-up
commands (edit the credentials file, `daemon-reload`, then `cd /mnt/nas` or
`sudo mount /mnt/nas` to trigger the automount). Re-running it once both
already exist is silent/idempotent. If the NAS's IP, share name, or this
machine's NAS-mount UID/GID ever change, edit the `NAS_*` variables at the
top of the script *and* the already-written `fstab` line by hand — the
script only ever appends, never rewrites, an existing entry.

`setup.d/30-nautilus-nas-bookmark.sh` appends `/mnt/nas` to
`~/.config/gtk-3.0/bookmarks` (Nautilus/GNOME Files' sidebar bookmark file,
not stow-managed — it's real user data, not a dotfile) so the mount shows in
the file manager sidebar. Idempotent like the others.

## No Alacritty

Removed from the repo entirely (all platforms) — Ghostty is the terminal everywhere now.

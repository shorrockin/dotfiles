# hosts/gustave/ — Omarchy host notes

## Steam controller udev rule

Arch's `steam-devices` package grants `/dev/uinput` access via a dynamic `uaccess` ACL tied to the logind seat session, which doesn't reliably apply in time for Steam's controller "Desktop Configuration" virtual-gamepad emulation. `udev/99-uinput-steam-controller.rules` is a static fallback (permanent `input` group ownership, mode 0660); `setup.d/40-steam-controller-udev.sh` copies it to `/etc/udev/rules.d/`, reloads udev, and adds the user to the `input` group. Gustave-specific because it's the only machine with a physical Steam controller — promote to top-level `install.d/` if another host picks one up.

## Steam controller battery bar widget

`plugins/steam-controller-battery/` is an Omarchy shell bar widget (Quickshell/QML) that shows a `<icon> NN%` pill in the bar **only while a controller is powered on** — the rest of the time it collapses to zero width. `BarWidget.qml` polls `~/.config/scripts/controller-battery` (the same script the NixOS waybar setup uses; `common/config/scripts/`) every 30s and parses its Waybar-style JSON; nothing connected → `class:"empty"` → hidden. Pill turns red (`bar.urgent`) at ≤15%; middle-click forces a re-poll.

Not stow-managed: `~/.config/omarchy/` is Omarchy-owned and periodically rewritten, so a symlinked plugin dir is fragile (cf. `~/.config/hypr/monitors.lua`, which lost its stow symlink). `setup.d/45-steam-controller-bar-widget.sh` instead `cmp`-copies the plugin files into `~/.config/omarchy/plugins/`, runs `omarchy-shell shell rescanPlugins`, and — if the widget has no bar-layout entry yet — runs `omarchy plugin enable steam-controller-battery --after omarchy.tray`. All idempotent; the enable half no-ops once `omarchy plugin list` reports it `enabled`.

Depends on the hidraw access from the udev rule above. `common/config/scripts/controller-battery` was hardened to fall back to `/usr/bin/python3` because `omarchy-shell` runs with a minimal PATH that has no mise shim. Gustave-specific for the same reason as the udev rule.

## No screen locking

`setup.d/50-disable-locking.sh` turns off both of Omarchy's session-lock paths, because gustave is a stay-at-home desktop where locking is just friction:

- **Lock before suspend** — `omarchy-sleep-lock.service` (per-user unit) watches logind's `PrepareForSleep` and locks via the Quickshell shell before suspend. The script `systemctl --user mask`s it, so `omarchy update` can't re-enable it. Undo: `systemctl --user unmask --now omarchy-sleep-lock.service`.
- **Idle lock** — `omarchy-shell` reads `idle.lock` (seconds) from `~/.config/omarchy/shell.json` and locks after that long idle. There's no off switch (`0` means lock *immediately*), so the script sets it to `1000000` (~11.5 days, under QML's 32-bit ms timer ceiling) via `jq`. `idle.screensaver` is left alone, so the display still blanks on idle.

`shell.json` isn't stow-managed (Omarchy owns it and hot-reloads it), so the script patches the live file in place and is idempotent — it re-asserts both settings on every install run.

## Synology NAS mount

`setup.d/20-nas-mount.sh` adds a CIFS mount of `//192.168.7.107/Upload` → `/mnt/nas` via `/etc/fstab`, using `x-systemd.automount,noauto,nofail,_netdev` so it mounts lazily rather than blocking boot if the NAS is offline. Mirrors the mount this machine had under NixOS (`nixos/modules/synology.nix`, now stale — not applied here).

Credentials aren't committed. The script creates `/etc/samba/smb-secrets` (root-only, mode 600) with empty `username=`/`password=` lines and, only the first time it creates either the credentials file or the fstab entry, prints the follow-up commands (edit credentials, `daemon-reload`, then `sudo mount /mnt/nas`). Re-running once both exist is silent/idempotent. If the NAS's IP, share, or UID/GID changes, edit `NAS_*` at the top of the script *and* the existing fstab line by hand — the script only appends, never rewrites.

`setup.d/30-nautilus-nas-bookmark.sh` appends `/mnt/nas` to `~/.config/gtk-3.0/bookmarks` (not stow-managed — real user data) so the mount shows in the Files sidebar. Idempotent.

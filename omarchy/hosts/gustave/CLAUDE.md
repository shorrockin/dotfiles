# hosts/gustave/ — Omarchy host notes

## Steam controller udev rule

Arch's `steam-devices` package grants `/dev/uinput` access via a dynamic `uaccess` ACL tied to the logind seat session, which doesn't reliably apply in time for Steam's controller "Desktop Configuration" virtual-gamepad emulation. `udev/99-uinput-steam-controller.rules` is a static fallback (permanent `input` group ownership, mode 0660); `setup.d/40-steam-controller-udev.sh` copies it to `/etc/udev/rules.d/`, reloads udev, and adds the user to the `input` group. Gustave-specific because it's the only machine with a physical Steam controller — promote to top-level `install.d/` if another host picks one up.

## No screen locking

`setup.d/50-disable-locking.sh` turns off both of Omarchy's session-lock paths, because gustave is a stay-at-home desktop where locking is just friction:

- **Lock before suspend** — `omarchy-sleep-lock.service` (per-user unit) watches logind's `PrepareForSleep` and locks via the Quickshell shell before suspend. The script `systemctl --user mask`s it, so `omarchy update` can't re-enable it. Undo: `systemctl --user unmask --now omarchy-sleep-lock.service`.
- **Idle lock** — `omarchy-shell` reads `idle.lock` (seconds) from `~/.config/omarchy/shell.json` and locks after that long idle. There's no off switch (`0` means lock *immediately*), so the script sets it to `1000000` (~11.5 days, under QML's 32-bit ms timer ceiling) via `jq`. `idle.screensaver` is left alone, so the display still blanks on idle.

`shell.json` isn't stow-managed (Omarchy owns it and hot-reloads it), so the script patches the live file in place and is idempotent — it re-asserts both settings on every install run.

## Synology NAS mount

`setup.d/20-nas-mount.sh` adds a CIFS mount of `//192.168.7.107/Upload` → `/mnt/nas` via `/etc/fstab`, using `x-systemd.automount,noauto,nofail,_netdev` so it mounts lazily rather than blocking boot if the NAS is offline. Mirrors the mount this machine had under NixOS (`nixos/modules/synology.nix`, now stale — not applied here).

Credentials aren't committed. The script creates `/etc/samba/smb-secrets` (root-only, mode 600) with empty `username=`/`password=` lines and, only the first time it creates either the credentials file or the fstab entry, prints the follow-up commands (edit credentials, `daemon-reload`, then `sudo mount /mnt/nas`). Re-running once both exist is silent/idempotent. If the NAS's IP, share, or UID/GID changes, edit `NAS_*` at the top of the script *and* the existing fstab line by hand — the script only appends, never rewrites.

`setup.d/30-nautilus-nas-bookmark.sh` appends `/mnt/nas` to `~/.config/gtk-3.0/bookmarks` (not stow-managed — real user data) so the mount shows in the Files sidebar. Idempotent.

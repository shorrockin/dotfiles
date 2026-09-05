# hosts/maelle/ — Omarchy host notes

`maelle` is the second Omarchy desktop profile. Its NVIDIA and monitor settings
remain unset until the exact hardware is known.

Running `omarchy/install.sh` on a machine whose hostname is exactly `maelle`
already installs the shared layers:

- `common/` for shell, terminal, tmux, Git, scripts, and other cross-platform
  config
- `omarchy/` for Omarchy packages, agent config, theme hooks, and shared
  Hyprland overrides

Add files here only when `maelle` must differ from another Omarchy machine:

- `config/` for files stowed into `~/.config`
- `setup.d/` for numbered, idempotent provisioning scripts
- hardware support directories such as `udev/` or `modprobe.d/` when a setup
  script installs their files
- `plugins/` for host-only Omarchy shell plugins copied by a setup script

Do not copy `gustave`'s NVIDIA hibernate fix, Steam Controller support, monitor
scale, Kinesis key remaps, or application shortcuts. The shared layer already
provides the general Steam rules, suspend power button, Synology mount, and
password-free lock policy requested for both desktops.

The Synology credentials and mounted file ownership both use the `chris`
account. Only the password remains a manual first-install step.

## Deferred settings

Add NVIDIA suspend or hibernate workarounds only after checking the installed
GPU and driver. Add `config/hypr/monitors.lua` after checking `hyprctl monitors
all` on Maelle. Add its name and email to `config/git/identity` later; the
shared Git config loads that optional file last so it overrides the inherited
personal identity.

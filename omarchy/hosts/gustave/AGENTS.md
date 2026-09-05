# hosts/gustave/ — Omarchy host notes

## Steam controller udev rule

Arch's `steam-devices` package grants `/dev/uinput` access via a dynamic `uaccess` ACL tied to the logind seat session, which doesn't reliably apply in time for Steam's controller "Desktop Configuration" virtual-gamepad emulation. `udev/99-uinput-steam-controller.rules` is a static fallback (permanent `input` group ownership, mode 0660); `setup.d/40-steam-controller-udev.sh` copies it to `/etc/udev/rules.d/`, reloads udev, and adds the user to the `input` group. Gustave-specific because it's the only machine with a physical Steam controller — promote to top-level `install.d/` if another host picks one up.

## Steam controller battery bar widget

`plugins/steam-controller-battery/` is an Omarchy shell bar widget (Quickshell/QML) that shows a `<icon> NN%` pill in the bar **only while a controller is powered on** — the rest of the time it collapses to zero width. `BarWidget.qml` polls `~/.config/scripts/controller-battery` (the same script the NixOS waybar setup uses; `common/config/scripts/`) every 30s and parses its Waybar-style JSON; nothing connected → `class:"empty"` → hidden. Pill turns red (`bar.urgent`) at ≤15%; middle-click forces a re-poll.

Not stow-managed: `~/.config/omarchy/` is Omarchy-owned and periodically rewritten, so a symlinked plugin dir is fragile (cf. `~/.config/hypr/monitors.lua`, which lost its stow symlink). `setup.d/45-steam-controller-bar-widget.sh` instead `cmp`-copies the plugin files into `~/.config/omarchy/plugins/`, runs `omarchy-shell shell rescanPlugins`, and — if the widget has no bar-layout entry yet — runs `omarchy plugin enable steam-controller-battery --after omarchy.tray`. All idempotent; the enable half no-ops once `omarchy plugin list` reports it `enabled`.

Depends on the hidraw access from the udev rule above. `common/config/scripts/controller-battery` was hardened to fall back to `/usr/bin/python3` because `omarchy-shell` runs with a minimal PATH that has no mise shim. Gustave-specific for the same reason as the udev rule.

## Shared desktop behavior

The password-free lock policy and Synology mount now live in the shared
`install.d/` layer because Maelle uses them too.

## Hyprland

`config/hypr/host.lua` contains the Kinesis 360 key remaps and Gustave's app
shortcuts. Shared Steam rules and the suspend power button remain in
`omarchy/config/hypr/overrides.lua`.

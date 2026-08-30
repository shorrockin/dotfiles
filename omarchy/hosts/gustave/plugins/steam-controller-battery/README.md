# steam-controller-battery — Omarchy bar widget

Shows a battery pill (`<icon> NN%`) in the Omarchy bar **only while a game
controller is powered on**. When nothing is connected the widget collapses to
zero width and disappears.

## How it works

`BarWidget.qml` polls `~/.config/scripts/controller-battery` every 30s (override
with `"intervalSeconds"` in the widget's `shell.json` layout entry). That script
— shared with the NixOS waybar setup in this repo — emits Waybar-style JSON:

- **Steam Controller Puck** (USB `28de:1304`): no kernel `power_supply` entry
  exists yet, so `steam-controller-battery` (Python) reads HID report `0x43`
  off `hidraw` and maps cell voltage to a percentage.
- **Bluetooth controllers** (Xbox Wireless, etc.): read via `bluetoothctl`.

The pill turns red at ≤15%. Middle-click forces an immediate re-poll.

## Install

Not stow-managed — `~/.config/omarchy/` is owned and rewritten by Omarchy, so a
symlinked plugin dir is fragile. `hosts/gustave/setup.d/45-steam-controller-bar-widget.sh`
copies this directory into `~/.config/omarchy/plugins/` and runs
`omarchy plugin enable steam-controller-battery` on every install run
(idempotent). Manual equivalent:

```bash
cp -r hosts/gustave/plugins/steam-controller-battery ~/.config/omarchy/plugins/
omarchy-shell shell rescanPlugins
omarchy plugin enable steam-controller-battery --after omarchy.tray
```

## Requirements

The seat user must be able to read the Puck's `hidraw` node — handled by
`hosts/gustave/setup.d/40-steam-controller-udev.sh` (adds the user to `input`
and group-owns the nodes). `/usr/bin/python3` must exist (Omarchy ships it).

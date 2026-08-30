#!/usr/bin/env bash
#
# Install and enable the "Steam Controller Battery" Omarchy bar widget.
#
# ~/.config/omarchy/ is owned and periodically rewritten by Omarchy, so the
# plugin is NOT stow-managed. We copy it in from the repo and re-assert the bar
# placement on every install run. Both halves are idempotent.
#
# The widget only paints while a controller is powered on; the rest of the time
# it collapses to nothing. It reads the battery via ~/.config/scripts/controller-battery
# (shared with the NixOS waybar setup), which needs the hidraw access granted by
# 40-steam-controller-udev.sh. Gustave-specific for the same reason that rule is.

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SRC="$DOTFILES_DIR/omarchy/hosts/$(hostname)/plugins/steam-controller-battery"
DST="$HOME/.config/omarchy/plugins/steam-controller-battery"
ID=steam-controller-battery

# 1. Sync plugin files into place.
changed=0
mkdir -p "$DST"
for f in manifest.json BarWidget.qml README.md; do
  if ! cmp -s "$SRC/$f" "$DST/$f" 2>/dev/null; then
    cp "$SRC/$f" "$DST/$f"
    changed=1
  fi
done

if [ "$changed" -eq 1 ]; then
  echo "  Installed plugin files -> $DST"
else
  echo "  Plugin files already up to date."
fi

# Nothing else to do if the shell isn't running (e.g. first-boot provisioning).
if ! command -v omarchy-shell >/dev/null || ! omarchy-shell shell rescanPlugins >/dev/null 2>&1; then
  echo "  Omarchy shell not reachable — it'll pick the plugin up on next start."
  echo "  Enable later with: omarchy plugin enable $ID --after omarchy.tray"
  exit 0
fi

# 2. Ensure the widget has a place in the bar. `omarchy plugin list` reports
#    STATE=enabled once a layout entry exists; only add one if it's missing.
state=$(omarchy plugin list 2>/dev/null | awk -v id="$ID" '$1 == id { print $2 }')
if [ "$state" = "enabled" ]; then
  echo "  Bar widget already enabled."
  exit 0
fi

# Wait for the async rescan to surface the plugin (mirrors omarchy-plugin-add).
for _ in $(seq 1 40); do
  if omarchy plugin list --json 2>/dev/null | jq -e --arg id "$ID" 'any(.[]; .id == $id)' >/dev/null; then
    break
  fi
  sleep 0.05
done

omarchy plugin enable "$ID" --after omarchy.tray
echo "  Enabled bar widget (after omarchy.tray)."

#!/usr/bin/env bash
set -e

HYPRLAND_LUA=~/.config/hypr/hyprland.lua
if [ -f "$HYPRLAND_LUA" ] && ! grep -q 'require("hypr.overrides")' "$HYPRLAND_LUA"; then
  printf '\nrequire("hypr.overrides")\n' >> "$HYPRLAND_LUA"
  echo "  Added require(\"hypr.overrides\") to $HYPRLAND_LUA"
else
  echo "  Already present or hyprland.lua not found — skipping."
fi

if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  echo "  Validating Hyprland config..."
  hyprctl reload
  hyprctl configerrors
fi

#!/usr/bin/env bash
set -e

HYPRLAND_LUA=~/.config/hypr/hyprland.lua
if [ -f "$HYPRLAND_LUA" ] && ! grep -q 'require("hypr.overrides")' "$HYPRLAND_LUA"; then
  printf '\nrequire("hypr.overrides")\n' >> "$HYPRLAND_LUA"
  echo "  Added require(\"hypr.overrides\") to $HYPRLAND_LUA"
else
  echo "  Already present or hyprland.lua not found — skipping."
fi

if command -v omarchy-hyprland-workspace-layout-default >/dev/null 2>&1; then
  layout_dir="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/workspace-layouts"
  layout_config="$layout_dir/default.lua"
  default_layout='o.workspace_mode({ default = "scrolling" })'

  # Only set the default. Omarchy's interactive setter also clears saved
  # layout choices for empty workspaces.
  if [[ ! -f "$layout_config" || "$(<"$layout_config")" != "$default_layout" ]]; then
    mkdir -p "$layout_dir"
    layout_tmp=$(mktemp "$layout_dir/.default.lua.XXXXXX")
    trap 'rm -f -- "$layout_tmp"' EXIT
    printf '%s\n' "$default_layout" > "$layout_tmp"
    mv -fT -- "$layout_tmp" "$layout_config"
    echo "  Set Omarchy's default workspace layout to scrolling."
  fi
fi

if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  echo "  Validating Hyprland config..."
  hyprctl reload
  hyprctl configerrors
fi

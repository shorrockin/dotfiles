#!/usr/bin/env bash
# Make Slack, Steam, and the WhatsApp web app follow the active Omarchy palette.

set -euo pipefail

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
APP_THEME_SOURCE="$DOTFILES_DIR/omarchy/app-themes"
WHATSAPP_EXTENSION="$HOME/.local/share/omarchy-app-themes/whatsapp"
MILLENNIUM_THEME="$HOME/.steam/steam/millennium/themes/omarchy"
MILLENNIUM_CONFIG="$HOME/.config/millennium/config.json"

install -d "$WHATSAPP_EXTENSION"
install -m 644 "$APP_THEME_SOURCE/whatsapp/extension/manifest.json" "$WHATSAPP_EXTENSION/manifest.json"
install -m 644 "$APP_THEME_SOURCE/whatsapp/extension/theme.js" "$WHATSAPP_EXTENSION/theme.js"

add_extension_to_flags() {
  local flags_file="$1"
  local line

  [[ -f $flags_file ]] || return 0
  grep -qF "$WHATSAPP_EXTENSION" "$flags_file" && return 0

  if grep -q '^--load-extension=' "$flags_file"; then
    line=$(grep -m1 '^--load-extension=' "$flags_file")
    sed -i --follow-symlinks "0,/^--load-extension=/{s|^--load-extension=.*|${line},${WHATSAPP_EXTENSION}|}" "$flags_file"
  else
    [[ -z $(tail -c1 "$flags_file") ]] || printf '\n' >>"$flags_file"
    printf '%s\n' "--load-extension=$WHATSAPP_EXTENSION" >>"$flags_file"
  fi
}

for browser in chromium chrome google-chrome brave brave-beta brave-nightly brave-origin microsoft-edge-stable; do
  add_extension_to_flags "$HOME/.config/$browser-flags.conf"
done

# Millennium loads local themes from Steam's data directory. The theme manifest
# deliberately has CSS only: no JavaScript, plugins, or network resources.
install -d "$MILLENNIUM_THEME"
install -m 644 "$APP_THEME_SOURCE/steam/skin.json" "$MILLENNIUM_THEME/skin.json"

activate_millennium_theme() {
  local config_dir config_tmp

  config_dir=$(dirname "$MILLENNIUM_CONFIG")
  install -d "$config_dir"
  config_tmp=$(mktemp "$config_dir/config.json.tmp.XXXXXX")

  if [[ -f $MILLENNIUM_CONFIG ]]; then
    if ! jq '.themes = ((.themes // {}) + {activeTheme: "omarchy"})' \
      "$MILLENNIUM_CONFIG" >"$config_tmp"; then
      rm -f "$config_tmp"
      echo "  Millennium config is not valid JSON; leaving it unchanged." >&2
      return 0
    fi
  else
    jq -n '{themes: {activeTheme: "omarchy"}}' >"$config_tmp"
  fi

  chmod 600 "$config_tmp"
  mv "$config_tmp" "$MILLENNIUM_CONFIG"
}

activate_millennium_theme

# Rebuild the active theme in place without changing its background or touching
# running applications, so the two new templates are immediately available.
if [[ -f $HOME/.local/state/omarchy/current/theme.name ]]; then
  current_theme=$(<"$HOME/.local/state/omarchy/current/theme.name")
  OMARCHY_PATH="$OMARCHY_PATH" OMARCHY_THEME_HEADLESS=1 OMARCHY_THEME_SKIP_BACKGROUND=1 \
    omarchy theme set "$current_theme"
  "$HOME/.config/omarchy/hooks/theme-set.d/30-app-themes" "$current_theme"
else
  echo "  No active Omarchy theme yet; app palettes will appear after the first theme selection."
fi

if [[ -f /usr/lib/slack/resources/app.asar ]]; then
  sudo install -Dm755 "$APP_THEME_SOURCE/slack/patch-asar.py" /usr/local/bin/omarchy-slack-theme-patch
  sudo install -Dm644 "$APP_THEME_SOURCE/slack/omarchy-slack-theme.hook" /etc/pacman.d/hooks/omarchy-slack-theme.hook
  sudo /usr/local/bin/omarchy-slack-theme-patch
  echo "  Slack palette installed. Fully quit and reopen Slack once."
else
  echo "  Slack is not installed — skipping its palette loader."
fi

echo "  WhatsApp palette installed. Restart its browser window once."
echo "  Steam palette installed. Fully quit and reopen Steam once."

#!/usr/bin/env bash
# Show Maelle's screensaver after ten minutes of inactivity.

set -e

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
SHELL_JSON="$HOME/.config/omarchy/shell.json"
SCREENSAVER_TIMEOUT=600

if [ ! -e "$SHELL_JSON" ]; then
  mkdir -p "$(dirname "$SHELL_JSON")"
  if [ -e "$OMARCHY_PATH/config/omarchy/shell.json" ]; then
    cp "$OMARCHY_PATH/config/omarchy/shell.json" "$SHELL_JSON"
  else
    echo '{"version":1}' >"$SHELL_JSON"
  fi
fi

if [ "$(jq -r '.idle.screensaver // empty' "$SHELL_JSON")" != "$SCREENSAVER_TIMEOUT" ]; then
  screensaver_tmp="$(mktemp)"
  jq --argjson timeout "$SCREENSAVER_TIMEOUT" '.idle.screensaver = $timeout' "$SHELL_JSON" >"$screensaver_tmp"
  mv "$screensaver_tmp" "$SHELL_JSON"
  echo "  Set idle.screensaver = $SCREENSAVER_TIMEOUT in shell.json"
else
  echo "  idle.screensaver already set to $SCREENSAVER_TIMEOUT in shell.json"
fi

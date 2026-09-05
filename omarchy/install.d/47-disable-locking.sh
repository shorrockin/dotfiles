#!/usr/bin/env bash
# Keep the screensaver, but do not require a password on either Omarchy desktop.

set -e

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"

# Disable the lock-before-suspend service. Masking survives Omarchy updates.
if [ "$(systemctl --user is-enabled omarchy-sleep-lock.service 2>/dev/null)" != "masked" ]; then
  systemctl --user mask --now omarchy-sleep-lock.service
  echo "  Masked omarchy-sleep-lock.service"
else
  echo "  omarchy-sleep-lock.service already masked"
fi

# Omarchy has no disabled value for idle.lock. Use a timeout long enough that it
# will not fire on a machine in regular use, while staying within QML's timer.
SHELL_JSON="$HOME/.config/omarchy/shell.json"
NEVER=1000000

if [ ! -e "$SHELL_JSON" ]; then
  mkdir -p "$(dirname "$SHELL_JSON")"
  if [ -e "$OMARCHY_PATH/config/omarchy/shell.json" ]; then
    cp "$OMARCHY_PATH/config/omarchy/shell.json" "$SHELL_JSON"
  else
    echo '{"version":1}' >"$SHELL_JSON"
  fi
fi

if [ "$(jq -r '.idle.lock // empty' "$SHELL_JSON")" != "$NEVER" ]; then
  lock_tmp="$(mktemp)"
  jq --argjson never "$NEVER" '.idle.lock = $never' "$SHELL_JSON" >"$lock_tmp"
  mv "$lock_tmp" "$SHELL_JSON"
  echo "  Set idle.lock = $NEVER in shell.json"
else
  echo "  idle.lock already disabled in shell.json"
fi

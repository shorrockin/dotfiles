#!/usr/bin/env bash
#
# Gustave is a desktop that never leaves the house, so screen locking is pure
# friction. Two independent mechanisms lock the session on Omarchy; disable
# both. Both are idempotent and re-asserted on every install run.

set -e

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"

# 1. Lock-before-suspend
#
# omarchy-sleep-lock.service is a per-user unit that watches logind's
# PrepareForSleep signal and locks via the Quickshell shell before the machine
# suspends. Mask it (symlink to /dev/null under ~/.config/systemd/user) so
# `omarchy update` can't quietly re-enable it. Unmask + enable to undo.
if [ "$(systemctl --user is-enabled omarchy-sleep-lock.service 2>/dev/null)" != "masked" ]; then
  systemctl --user mask --now omarchy-sleep-lock.service
  echo "  Masked omarchy-sleep-lock.service (no lock before suspend)"
else
  echo "  omarchy-sleep-lock.service already masked"
fi

# 2. Idle lock
#
# omarchy-shell reads idle.lock (seconds) from shell.json and locks the session
# after that long idle. There is no off switch — a value of 0 means "lock
# immediately" — so push the timeout far enough out that it never fires in a
# machine that gets daily use. The screensaver timeout (idle.screensaver) is
# left untouched, so the display still blanks on idle.
SHELL_JSON="$HOME/.config/omarchy/shell.json"
NEVER=1000000 # ~11.5 days; stays under QML's 32-bit millisecond timer ceiling

if [ ! -e "$SHELL_JSON" ]; then
  mkdir -p "$(dirname "$SHELL_JSON")"
  if [ -e "$OMARCHY_PATH/config/omarchy/shell.json" ]; then
    cp "$OMARCHY_PATH/config/omarchy/shell.json" "$SHELL_JSON"
  else
    echo '{"version":1}' >"$SHELL_JSON"
  fi
fi

if [ "$(jq -r '.idle.lock // empty' "$SHELL_JSON")" != "$NEVER" ]; then
  tmp="$(mktemp)"
  jq --argjson never "$NEVER" '.idle.lock = $never' "$SHELL_JSON" >"$tmp"
  mv "$tmp" "$SHELL_JSON"
  echo "  Set idle.lock = $NEVER in shell.json (no idle lock; hot-reloads)"
else
  echo "  idle.lock already disabled in shell.json"
fi

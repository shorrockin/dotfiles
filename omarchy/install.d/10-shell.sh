#!/usr/bin/env bash
set -e

FISH_PATH="$(command -v fish)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
  chsh -s "$FISH_PATH"
  echo "Default shell changed to fish. Takes effect on next login."
else
  echo "fish is already the default shell."
fi

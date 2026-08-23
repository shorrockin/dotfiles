#!/usr/bin/env bash
set -e

HOST_SETUP="$DOTFILES_DIR/omarchy/hosts/$(hostname)/setup.sh"
if [ -x "$HOST_SETUP" ]; then
  "$HOST_SETUP"
else
  echo "  No host-specific setup for $(hostname) — skipping."
fi

#!/usr/bin/env bash
set -e

HOST_SETUP_DIR="$DOTFILES_DIR/omarchy/hosts/$(hostname)/setup.d"
if [ -d "$HOST_SETUP_DIR" ]; then
  for step in "$HOST_SETUP_DIR"/*.sh; do
    echo "  -- $(basename "$step" .sh | sed 's/^[0-9]*-//; s/-/ /g') --"
    "$step"
  done
else
  echo "  No host-specific setup for $(hostname) — skipping."
fi

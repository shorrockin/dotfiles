#!/usr/bin/env bash
set -e

UDEV_RULE_SRC="$DOTFILES_DIR/omarchy/udev/99-uinput-steam-controller.rules"
UDEV_RULE_DST=/etc/udev/rules.d/99-uinput-steam-controller.rules
if ! cmp -s "$UDEV_RULE_SRC" "$UDEV_RULE_DST" 2>/dev/null; then
  sudo cp "$UDEV_RULE_SRC" "$UDEV_RULE_DST"
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  echo "  Installed and reloaded udev rules."
else
  echo "  Already up to date."
fi
if ! id -nG "$USER" | grep -qw input; then
  sudo usermod -aG input "$USER"
  echo "  Added $USER to the 'input' group. Log out and back in for it to take effect."
else
  echo "  $USER already in the 'input' group."
fi

#!/usr/bin/env bash
#
# Bootstrap this dotfiles repo on an Omarchy box: installs missing packages,
# backs up stock config that would conflict with stow, symlinks everything via
# `dots`, installs the Steam controller udev rule, and wires the one Hyprland
# override hook into hyprland.lua.
#
# Safe to re-run: package installs, the tmux plugin clone, the udev rule
# install, and the hyprland.lua edit are all idempotent, and `dots` only
# backs up a target when it's a real (non-symlink) file/dir in the way of stow.

set -e

DOTFILES_DIR=~/dotfiles

if [ ! -d /usr/share/omarchy ]; then
  echo "This doesn't look like an Omarchy system (/usr/share/omarchy not found). Aborting." >&2
  exit 1
fi

echo "== Installing packages =="
omarchy pkg add fish git-delta stow ttf-meslo-nerd most libqalculate cmatrix
omarchy pkg aur add oh-my-posh-bin

echo "== Setting fish as default shell =="
FISH_PATH="$(command -v fish)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
  chsh -s "$FISH_PATH"
  echo "Default shell changed to fish. Takes effect on next login."
else
  echo "fish is already the default shell."
fi

echo "== Stowing dotfiles (omarchy profile) =="
echo "(stock config that would conflict — nvim, ghostty, btop, etc. — is backed up automatically as *.pre-stow-backup.<timestamp>)"
"$DOTFILES_DIR/config/scripts/dots" stow

echo "== Installing tmux plugin manager =="
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
~/.tmux/plugins/tpm/bin/install_plugins

echo "== Installing Steam controller udev rule =="
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

echo "== Wiring hypr override hook into hyprland.lua =="
HYPRLAND_LUA=~/.config/hypr/hyprland.lua
if [ -f "$HYPRLAND_LUA" ] && ! grep -q 'require("hypr.overrides")' "$HYPRLAND_LUA"; then
  printf '\nrequire("hypr.overrides")\n' >> "$HYPRLAND_LUA"
  echo "  Added require(\"hypr.overrides\") to $HYPRLAND_LUA"
else
  echo "  Already present or hyprland.lua not found — skipping."
fi

if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  echo "== Validating Hyprland config =="
  hyprctl reload
  hyprctl configerrors
fi

echo "== Running machine-specific setup =="
"$DOTFILES_DIR/omarchy/gustave.sh"

echo "== Done =="
echo "Backed-up stock configs (safe to delete once you've confirmed you don't need them): find ~/.config -name '*.pre-stow-backup.*'"
echo "fish: run 'omarchy restart terminal' or open a new terminal to pick it up."

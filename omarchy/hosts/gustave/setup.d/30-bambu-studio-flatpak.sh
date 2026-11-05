#!/usr/bin/env bash
set -e

# Keep Bambu Studio isolated from Arch's rolling system libraries. The AUR
# bambu-studio package builds the application and its bundled dependencies on
# this machine, making routine Omarchy upgrades slow and prone to build
# failures. Bambu Lab recommends the Flathub build for distribution-independent
# Linux installs.
omarchy pkg add flatpak

flatpak remote-add --user --if-not-exists \
  flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user --noninteractive -y \
  flathub com.bambulab.BambuStudio

# Remove the legacy source-built package only after the replacement has been
# installed successfully. Pacman never removes application data in $HOME.
if pacman -Qq bambu-studio >/dev/null 2>&1; then
  echo "  Removing legacy source-built Bambu Studio package"
  sudo pacman -Rns --noconfirm bambu-studio
fi

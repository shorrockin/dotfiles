#!/usr/bin/env bash
set -e

# The Arch package provides this user service. It is tied to Omarchy's
# graphical-session target and reads ~/.config/hypr/hypridle.conf.
systemctl --user enable --now hypridle.service

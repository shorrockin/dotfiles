#!/usr/bin/env bash
#
# Machine-specific setup for gustave. Safe to call from install.sh on any
# Omarchy box — no-ops unless the hostname matches.

set -e

if [ "$(hostname)" != "gustave" ]; then
  exit 0
fi

echo "== Enabling NVIDIA hibernate/suspend services (gustave-specific) =="
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-suspend-then-hibernate.service

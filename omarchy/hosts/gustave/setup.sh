#!/usr/bin/env bash
#
# Machine-specific setup for gustave. Only ever invoked when the current
# hostname is "gustave" — the caller (install.d/60-host-setup.sh) is the gate.

set -e

echo "  Enabling NVIDIA hibernate/suspend services (gustave-specific)"
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-suspend-then-hibernate.service

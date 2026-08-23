#!/usr/bin/env bash
set -e

echo "  Enabling NVIDIA hibernate/suspend services"
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-suspend-then-hibernate.service

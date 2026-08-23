#!/usr/bin/env bash
set -e

echo "  Enabling NVIDIA hibernate/suspend services"
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-suspend-then-hibernate.service

NEEDS_INITRAMFS_REBUILD=0

# NVreg_PreserveVideoMemoryAllocations=1 is required for the services above to
# actually work — without it, hibernation resume can fail with
# nv_pmops_freeze returning -EIO, discarding the hibernation image and
# forcing a fresh boot instead (looks like a crash on wake).
MODPROBE_SRC="$DOTFILES_DIR/omarchy/hosts/gustave/modprobe.d/nvidia-power-management.conf"
MODPROBE_DST=/etc/modprobe.d/nvidia-power-management.conf
if ! cmp -s "$MODPROBE_SRC" "$MODPROBE_DST" 2>/dev/null; then
  sudo cp "$MODPROBE_SRC" "$MODPROBE_DST"
  echo "  Installed $MODPROBE_DST"
  NEEDS_INITRAMFS_REBUILD=1
else
  echo "  $MODPROBE_DST already up to date"
fi

# Even with the above, hibernation resume still failed on gustave: this GPU
# has no hybrid iGPU to fall back to, and Omarchy's installer force-loads
# nvidia early (for a seamless boot splash) via this drop-in. That means the
# freshly-booted resume kernel already has nvidia bound to the GPU by the
# time it tries to restore the hibernation image, and the freeze fails the
# same way. Disabling early KMS for nvidia — trading a fully seamless splash
# for working hibernate — fixed the identical failure for another
# single-GPU-desktop Omarchy user: https://github.com/basecamp/omarchy/issues/5554
NVIDIA_EARLY_KMS=/etc/mkinitcpio.conf.d/nvidia.conf
if [ -f "$NVIDIA_EARLY_KMS" ]; then
  sudo mv "$NVIDIA_EARLY_KMS" "$NVIDIA_EARLY_KMS.disabled"
  echo "  Disabled early NVIDIA KMS ($NVIDIA_EARLY_KMS -> .disabled)"
  NEEDS_INITRAMFS_REBUILD=1
else
  echo "  Early NVIDIA KMS already disabled"
fi

if [ "$NEEDS_INITRAMFS_REBUILD" = 1 ]; then
  echo "  Rebuilding initramfs"
  sudo mkinitcpio -P
fi

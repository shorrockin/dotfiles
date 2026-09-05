#!/usr/bin/env bash
# Configure the Synology share used by both Omarchy desktops. Credentials stay
# outside the repository and are filled in once on each machine.

set -e

NAS_HOST=192.168.7.107
NAS_SHARE=Upload
NAS_MOUNT=/mnt/nas
NAS_CREDENTIALS=/etc/samba/smb-secrets

CREDENTIALS_JUST_CREATED=0
if [ ! -f "$NAS_CREDENTIALS" ]; then
  printf 'username=chris\npassword=\n' | sudo install -D -m 600 -o root -g root /dev/stdin "$NAS_CREDENTIALS"
  CREDENTIALS_JUST_CREATED=1
  echo "  Created NAS credentials placeholder at $NAS_CREDENTIALS"
fi

echo "  Ensuring $NAS_MOUNT exists"
sudo mkdir -p "$NAS_MOUNT"

FSTAB_JUST_ADDED=0
if ! grep -q "^//$NAS_HOST/$NAS_SHARE" /etc/fstab; then
  printf '//%s/%s %s cifs rw,vers=3.0,credentials=%s,uid=%s,gid=%s,file_mode=0660,dir_mode=0770,x-systemd.automount,noauto,nofail,_netdev 0 0\n' \
    "$NAS_HOST" "$NAS_SHARE" "$NAS_MOUNT" "$NAS_CREDENTIALS" "$(id -u chris)" "$(id -g chris)" | sudo tee -a /etc/fstab >/dev/null
  sudo systemctl daemon-reload
  FSTAB_JUST_ADDED=1
  echo "  Added $NAS_MOUNT to /etc/fstab (automounts on first access)"
fi

if [ "$CREDENTIALS_JUST_CREATED" = 1 ] || [ "$FSTAB_JUST_ADDED" = 1 ]; then
  cat <<EOF

  NAS mount configured but not yet usable. One manual step remains:

    sudo nvim $NAS_CREDENTIALS
      # fill in:
      #   username=chris
      #   password=<your synology password>

  Then mount it:

    sudo systemctl daemon-reload
    cd $NAS_MOUNT   # triggers the automount, or: sudo mount $NAS_MOUNT

EOF
fi

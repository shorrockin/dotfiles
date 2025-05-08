{ config, pkgs, ... }: {
  fileSystems."/mnt/nas" = {
    device = "//192.168.7.107/Upload"; # adjust IP/share
    fsType = "cifs";
    options = [
      "rw"
      "vers=3.0"
      "credentials=/etc/nixos/smb-secrets"
      "uid=1000" # replace with your UID
      "gid=100" # replace with your GID (often "users")
      "file_mode=0660"
      "dir_mode=0770"
      "x-systemd.automount"
      "noauto"
      "nofail"
      "_netdev"
      "users"
    ];
  };
}

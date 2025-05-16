{ config, pkgs, ... }: {
  networking.hostName = "gustave"; # Change as needed
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # allows the use of flakes, is this still needed if this is imported 
  # by a flake? not sure
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [ # Include the results of the hardware scan.
    ../modules/hardware-configuration.nix
    ../modules/system.nix
    ../modules/nvidia.nix
    ../modules/packages.nix
    ../modules/users.nix
    ../modules/hyprland.nix
    ../modules/synology.nix
    ../modules/random-wallpaper.nix
    # hibernate seems to be a bit broken
    # ../modules/hibernate.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

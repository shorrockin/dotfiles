{
  config,
  pkgs,
  lib,
  ...
}:
{
  # System-level packages only (user packages are in home/packages.nix)
  environment.systemPackages = with pkgs; [
    stow # symlink manager
    zsh # needed at system level for tool compatibility
    steam-devices-udev-rules # udev rules for Steam controllers and other gaming hardware
  ];

  # programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.dconf.enable = true;

  # Install steam with wrapper commands for better experience
  # can run wrappers with launch options and:
  # - gamemoderun %command%
  # - gamescope %command%
  # - mangohud %command%
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.extest.enable = true;
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # Logitech wireless devices: udev rules (so the mouse's hidraw is user-accessible)
  # and solaar (used by config/scripts/mouse-battery to query battery % over HID++,
  # since the kernel only caches a coarse capacity_level on reconnect).
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
}

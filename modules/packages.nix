{ config, pkgs, lib, ... }: {
  # System-level packages only (user packages are in home/packages.nix)
  environment.systemPackages = with pkgs; [
    stow # symlink manager
    zsh # needed at system level for tool compatibility
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
  programs.gamemode.enable = true;
}

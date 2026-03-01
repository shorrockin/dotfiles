{ config, pkgs, lib, ... }:

{
  home.username = "chris";
  home.homeDirectory = "/home/chris";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  home.file.".local/share/applications/mimeapps.list".force = true;

  imports = [
    ./packages.nix
    ./services/random-wallpaper.nix
    ./services/gtk.nix
    ./programs/hyprflow.nix
    ./programs/vicinae.nix
  ];
}

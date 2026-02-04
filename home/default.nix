{ config, pkgs, lib, ... }:

{
  home.username = "chris";
  home.homeDirectory = "/home/chris";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./services/random-wallpaper.nix
    ./services/gtk.nix
    ./programs/hyprflow.nix
    ./programs/vicinae.nix
  ];
}

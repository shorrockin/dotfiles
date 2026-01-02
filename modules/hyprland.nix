{ config, pkgs, inputs, system, ... }:
let
  hyprlandPkg = inputs.hyprland.packages.${system}.hyprland;
  hyprlandPortal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  hyprPlugins = inputs.hyprland-plugins.packages.${system};
  pluginDir = pkgs.symlinkJoin {
    name = "hyprland-plugins";
    paths = [ hyprPlugins.hyprscrolling ];
  };
in {
  services.displayManager.enable = true;

  # seems like this shouldn't be needed, at least as i understand
  # sddm, but ui seems to be reliant on this
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprlandPkg;
    portalPackage = hyprlandPortal;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # Default browser
    BROWSER = "vivaldi";
    # Hyprland plugins directory
    HYPR_PLUGIN_DIR = "${pluginDir}";
  };

  # allows interaction between apps and proper dark mode support
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    hyprlandPortal
    pkgs.xdg-desktop-portal-gtk
  ];
  xdg.portal.config.common = {
    default = [ "hyprland" "gtk" ];
    "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
  };
}

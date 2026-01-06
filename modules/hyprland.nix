{ config, pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = [ pkgs-unstable.hyprpaper ];
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
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # Default browser
    BROWSER = "vivaldi";
  };

  # allows interaction between apps and proper dark mode support
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common = {
    default = [ "hyprland" "gtk" ];
    "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
  };
}

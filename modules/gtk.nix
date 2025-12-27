{ config, pkgs, lib, ... }: {
  # GTK/Qt theme configuration via system-wide settings
  # Catppuccin Mocha theme with Papirus icons

  # Create system-wide GTK settings
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=catppuccin-mocha-mauve-standard
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=catppuccin-mocha-dark-cursors
      gtk-cursor-theme-size=24
      gtk-icon-theme-name=Papirus-Dark
      gtk-font-name=DejaVu Sans 11
    '';

    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=catppuccin-mocha-mauve-standard
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=catppuccin-mocha-dark-cursors
      gtk-cursor-theme-size=24
      gtk-icon-theme-name=Papirus-Dark
      gtk-font-name=DejaVu Sans 11
    '';
  };

  # Environment variables
  environment.variables = {
    GTK_THEME = "catppuccin-mocha-mauve-standard";
    QT_QPA_PLATFORMTHEME = "kvantum";
    QT_STYLE_OVERRIDE = "kvantum";
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
  };

  # Enable dconf for gsettings support
  programs.dconf.enable = true;

  # Add necessary packages for theme support
  environment.systemPackages = with pkgs; [
    dconf
    gsettings-desktop-schemas
    glib # for gsettings
  ];

  # Create a systemd user service to set themes on login via gsettings
  systemd.user.services.gtk-theme-settings = {
    description = "Set GTK theme settings via gsettings";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-gtk-theme" ''
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard'
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'catppuccin-mocha-dark-cursors'
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      '';
      RemainAfterExit = true;
    };
  };
}
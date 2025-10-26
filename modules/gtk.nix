{ config, pkgs, lib, ... }: {
  # GTK dark theme configuration via system-wide settings
  # This approach is fully declarative and restorable
  
  # Create system-wide GTK settings
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Adwaita-dark
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Adwaita
      gtk-icon-theme-name=Adwaita
    '';
    
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Adwaita-dark
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Adwaita
      gtk-icon-theme-name=Adwaita
    '';
  };
  
  # Environment variables as fallback
  environment.variables = {
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  # Enable dconf for gsettings support
  programs.dconf.enable = true;
  
  # Add necessary packages for dark theme support
  environment.systemPackages = with pkgs; [
    dconf
    gsettings-desktop-schemas
    glib # for gsettings
  ];

  # Create a systemd user service to set dark mode on login
  systemd.user.services.gtk-dark-mode = {
    description = "Set GTK dark mode via gsettings";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
      RemainAfterExit = true;
    };
  };
}
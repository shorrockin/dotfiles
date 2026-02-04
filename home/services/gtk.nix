{ config, pkgs, lib, ... }: {
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "mauve" ];
        size = "standard";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };

    font = {
      name = "DejaVu Sans";
      size = 11;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Replaces the old gsettings systemd user service
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "catppuccin-mocha-mauve-standard";
      icon-theme = "Papirus-Dark";
      cursor-theme = "catppuccin-mocha-dark-cursors";
      color-scheme = "prefer-dark";
    };
  };

  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      variant = "mocha";
      accent = "mauve";
    })
    (lib.hiPrio catppuccin-papirus-folders)
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    dconf
    glib
    gsettings-desktop-schemas
  ];

  home.sessionVariables = {
    GTK_THEME = "catppuccin-mocha-mauve-standard";
    QT_QPA_PLATFORMTHEME = "kvantum";
    QT_STYLE_OVERRIDE = "kvantum";
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
  };
}

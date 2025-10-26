{ config, pkgs, lib, ... }: {
  # GTK dark theme configuration via environment variables
  # This approach is fully declarative and restorable
  
  environment.variables = {
    # Set GTK theme to dark mode system-wide
    GTK_THEME = "Adwaita-dark";
    
    # Also set Qt applications to use dark theme for consistency
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
}
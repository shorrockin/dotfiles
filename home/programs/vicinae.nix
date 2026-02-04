{ config, pkgs, ... }: {
  services.vicinae = {
    enable = true;
    package = pkgs.vicinae; # use nixpkgs version (monolithic binary, server built-in)
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
  };
}

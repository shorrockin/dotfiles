{ config, pkgs, lib, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable suspend and hibernate support
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  services.logind.settings.Login = {
    HandleRebootKey = "suspend";
    HandlePowerKey = "suspend";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = lib.mkForce false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocales = [ "en_GB.UTF-8/UTF-8" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts.packages = [ pkgs.font-awesome pkgs.nerd-fonts.meslo-lg ];

  # automatically updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # automatic cleanup 
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # system.activationscripts.tpm = {
  #   text = ''
  #     mkdir -p /home/chris/.tmux/plugins
  #     if [ ! -d "/home/chris/.tmux/plugins/tpm" ]; then
  #       git clone https://github.com/tmux-plugins/tpm /home/chris/.tmux/plugins/tpm
  #     fi
  #     chown -r chris:users /home/chris/.tmux
  #   '';
  # };
  # environment.etc."tmux.conf".source = /home/chris/dotfiles/tmux.conf;
  #
  # system.activationscripts.linktmuxconf = {
  #   text = ''
  #     ln -sf /etc/tmux.conf /home/chris/.tmux.conf
  #     chown chris:users /home/chris/.tmux.conf
  #   '';
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

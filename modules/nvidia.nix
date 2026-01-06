{ config, pkgs, lib, ... }: {
  # Post-resume delay to give GPU time to stabilize before display restoration
  systemd.services.nvidia-post-resume-fix = {
    description = "NVIDIA post-resume display stabilization delay";
    after = [ "nvidia-resume.service" ];
    before = [ "post-resume.target" ];
    wantedBy = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/sleep 2";
    };
  };
  # Enable OpenGL
  hardware.graphics = { enable = true; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Maybe recommended for wayland? But only if problems
  # hardware.nvidia.modesetting.enable = true;

  # Enable 10GB shader cache for OpenGL applications 
  environment.variables = {
    __GL_SHADER_DISK_CACHE_SIZE = "10737418240"; # 10GB in bytes
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # NOTE: This requires hardware.nvidia.prime.offload.enable = true; 
    # which is usually for laptops. Enabling it on desktops can cause 
    # unresponsiveness or rebuild errors.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Recommended for RTX 20+ series, especially on Wayland, as it moves firmware 
    # to the GSP for better power management and stability.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}


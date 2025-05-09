{ config, pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # core os level utils
    zsh
    tmux
    git
    tig
    wget
    stow
    fzf
    gcc
    btop
    most
    eza
    bat
    zoxide
    neofetch

    # general development
    alacritty
    kitty # backup to alacritty
    go
    rustc

    # neovim & plugin dependencies
    neovim
    ripgrep
    jq
    unzip
    python3Minimal
    nodejs_22

    # hyprland specific
    kdePackages.dolphin # file manager
    rofi-wayland # app launcher
    wl-clipboard # system clipboard
    hyprpanel # bar, replaces all the following
    hyprpaper # wallpaper
    hypridle # idle management
    hyprshot # screenshots

    # general aps
    _1password-cli
    _1password-gui
    slack
    discord
    obsidian
    mangohud # game overlap for fps
    google-chrome
    # protonup # https://www.youtube.com/watch?v=qlfm3MEbqYA&t=392s
  ];

  # Needed so we can add it as a shell below
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam with wrapper commands for better experience
  # can run wrappers with launch options and:
  # - gamemoderun %command%
  # - gamescope %command%
  # - mangohud %command%
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

}

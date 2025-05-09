{ config, pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # terminal 
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
    jtbl

    # general development
    alacritty
    kitty
    go
    rustc

    # neovim & plugin dependencies
    neovim
    ripgrep
    jq
    unzip
    python3Minimal
    nodejs_22

    # wayland / hyprland 
    kdePackages.dolphin # file manager
    rofi-wayland # app launcher
    rofimoji # emoji selector in rofi
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
    bambu-studio
    # protonup # https://www.youtube.com/watch?v=qlfm3MEbqYA&t=392s
  ];

  programs.zsh.enable = true;
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

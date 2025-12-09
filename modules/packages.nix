{ config, pkgs, lib, pkgs-unstable, vicinae-pkg, ... }: {
  imports = [ ./ollama.nix ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # terminal zsh
    zsh
    zoxide # quick cd

    # terminal fish
    fish
    starship # prompt

    # terminal git
    git
    delta # better git diffs
    tig # show git history
    lazygit # git history in a tui

    # terminal 
    tmux # multiplexer
    wget # http fetcher
    stow # symlink manager
    fzf # fuzzy finder
    btop # better top
    most # most > less > more
    eza # better ls
    bat # more cat
    neofetch # computer info
    cmatrix # terminal matrix
    jtbl # json in the terminal
    libqalculate # qalc: calculator
    yazi # terminal file manager
    hyperfine # terminal benchmarking
    tldr # succinct man pages
    dust # better du / df
    poppler-utils # pdf tools

    # general development
    ghostty
    alacritty
    kitty
    go
    rustc
    cargo
    gcc
    gnumake
    pkgs-unstable.claude-code
    pkgs-unstable.gemini-cli
    pkgs-unstable.opencode
    (python3.withPackages (ps:
      with ps; [
        openai-whisper # for dictation system
        pyaudio # for dictation system
      ]))
    nodejs_22

    # dictation system
    wtype # wayland keyboard input
    ffmpeg # audio recording
    libnotify # desktop notifications

    # neovim & plugin dependencies
    neovim
    ripgrep
    jq
    unzip

    # wayland / hyprland
    nautilus # file manager
    vicinae-pkg # app launcher (replaces walker)
    wl-clipboard # system clipboard
    hyprpanel # bar, replaces all the following
    hyprpaper # wallpaper
    hypridle # idle management
    hyprshot # screenshots
    mpv # used to show wallpaper fullscreen
    wdisplays # display manager
    wlr-randr # for adjusting resolutions
    # moonlight-qt # game streaming client
    # sunshine # moonlight: game streaming server
    # hyprlock # lock screen

    # general aps
    _1password-cli
    _1password-gui
    slack
    discord
    obsidian
    mangohud # game overlap for fps
    google-chrome
    localsend # allows sharing across devices on local network

    #  see bambustudio.nix
    # orca-slicer
    # (bambu-studio.overrideAttrs (previousAttrs: {
    #   version = "01.00.01.50";
    #   src = fetchFromGitHub {
    #     owner = "bambulab";
    #     repo = "BambuStudio";
    #     rev = "v01.00.01.50";
    #     hash = "sha256-7mkrPl2CQSfc1lRjl1ilwxdYcK5iRU//QGKmdCicK30=";
    #   };
    # }))

    # protonup # https://www.youtube.com/watch?v=qlfm3MEbqYA&t=392s
  ];

  # programs.zsh.enable = true;
  programs.fish.enable = true;
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

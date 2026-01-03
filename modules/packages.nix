{ config, pkgs, lib, pkgs-unstable, vicinae-pkg, ... }: {
  # imports = [ ./ollama.nix ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # terminal 
    zsh
    fish
    starship # prompt
    zoxide # quick cd

    # git
    git
    delta # better git diffs
    tig # show git history
    lazygit # git history in a tui

    # terminal utils
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
    ripgrep # recursive searching
    jq # json parsing
    unzip # unzip

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
    nodejs_22

    ffmpeg # audio recording
    libnotify # desktop notifications

    # neovim & plugin dependencies
    neovim

    # LSP servers
    lua-language-server # lua_ls
    nixd # nix
    pyright # python
    marksman # markdown
    yaml-language-server # yamlls
    nodePackages.bash-language-server # bashls
    elixir-ls # elixirls
    gopls # go
    rust-analyzer # rust
    nodePackages.vscode-langservers-extracted # jsonls, html, cssls, eslint

    # Formatters (used by conform.nvim)
    stylua # lua
    nixfmt-classic # nix

    # wayland / hyprland
    nautilus # file manager
    vicinae-pkg # app launcher (replaces walker)
    wl-clipboard # system clipboard
    waybar # status bar
    wttrbar # weather for waybar
    swaynotificationcenter # notification daemon
    playerctl # media player controls
    pavucontrol # pulseaudio volume control GUI
    blueman # bluetooth manager GUI
    # hyprpanel # bar, replaced by waybar
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
    vivaldi
    localsend # allows sharing across devices on local network
    whatsapp-electron
    pinta # basic image editing: https://www.pinta-project.com
    mpv # general purpose media player
    impala # wifi management tui
    bluetui # bluetooth management tui
    fastfetch # system about screen

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

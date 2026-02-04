{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    # Core & Shells
    zsh # interactive shell
    fish # user friendly shell
    oh-my-posh # prompt with async git support
    tmux # multiplexer

    # Git & TUI
    git # version control
    delta # better git diffs
    tig # show git history
    lazygit # git history in a tui

    # CLI Utilities
    zoxide # quick cd
    fzf # fuzzy finder
    btop # better top
    most # most > less > more
    eza # better ls
    bat # more cat
    fastfetch # system about screen
    ripgrep # recursive searching
    jq # json parsing
    yazi # terminal file manager
    tldr # succinct man pages
    dust # better du / df
    unzip # extraction tool
    wget # network downloader
    jtbl # json in the terminal
    libqalculate # calculator
    hyperfine # terminal benchmarking
    poppler-utils # pdf utilities
    nsxiv # image viewer
    cmatrix # matrix effect
    ffmpeg # multimedia framework
    libnotify # notification library
    impala # wifi management tui
    bluetui # bluetooth management tui
    yq # yaml processor

    # Development Languages & Tools
    ghostty # terminal emulator
    alacritty # terminal emulator
    kitty # terminal emulator
    go # go programming language
    rustc # rust compiler
    cargo # rust package manager
    gcc # c compiler
    gnumake # build tool
    nodejs_22 # javascript runtime
    python3 # python programming language
    pkgs-unstable.gemini-cli # gemini ai cli
    pkgs-unstable.opencode # opencode ai cli

    # Neovim & LSP Support
    neovim # text editor
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
    stylua # lua
    nixfmt # nix

    # Wayland / Hyprland Environment
    nautilus # file manager
    quickshell # desktop shell toolkit
    wl-clipboard # system clipboard
    waybar # status bar
    wttrbar # weather for waybar
    swaynotificationcenter # notification daemon
    playerctl # media player controls
    pavucontrol # pulseaudio volume control GUI
    blueman # bluetooth manager GUI
    hypridle # idle management
    hyprshot # screenshots
    hyprlock # lock screen
    wlogout # logout/power menu
    mpv # general purpose media player
    wdisplays # display manager
    wlr-randr # for adjusting resolutions
    kooha # simple screen recorder for wayland

    # Desktop Applications
    _1password-cli # password manager cli
    _1password-gui # password manager gui
    slack # communication tool
    discord # communication tool
    obsidian # note taking app
    mangohud # game overlap for fps
    google-chrome # web browser
    vivaldi # web browser
    localsend # sharing across devices on local network
    whatsapp-electron # messaging app
    pinta # basic image editing: https://www.pinta-project.com
    ytmdesktop # youtube music for the desktop
  ];
}

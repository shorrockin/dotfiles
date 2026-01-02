# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository with dual configuration management:
- **NixOS Configuration**: Declarative system configuration using Nix flakes
- **Traditional Dotfiles**: GNU Stow-based symlink management for non-NixOS systems

The repository assumes it's cloned to `~/dotfiles`.

## Common Commands

### NixOS System Management
```bash
# Rebuild NixOS system (includes git commit prompt)
config/scripts/nix-rebuild
# or
sudo nixos-rebuild switch --flake .#gustave

# Update flake inputs
nix flake update
```

### Traditional Dotfile Management
```bash
# Initial setup - symlinks all dotfiles
config/scripts/dots stow

# Re-link dotfiles (useful after changes)
config/scripts/dots restow

# Remove all symlinks
config/scripts/dots delete
```

### Development Tools
```bash
# Create/switch tmux sessions for projects
config/scripts/tmux-sessionizer

# After initial setup, bat needs cache rebuild
bat cache --build

# Tmux plugins need installation (prefix + I)
# Usually <C-a>I
```

## Architecture

### Directory Structure
- `flake.nix` + `flake.lock`: Nix flake system definition
- `hosts/`: Host-specific configurations (currently `gustave.nix`)
- `modules/`: Modular NixOS configuration components
- `config/`: Application configs → `~/.config/` (via stow)
- `dots/`: Home directory dotfiles → `~/` (via stow)

### Key Configuration Modules
- `modules/system.nix`: Core system settings and services
- `modules/packages.nix`: System-wide package declarations
- `modules/hyprland.nix`: Wayland compositor setup
- `modules/nvidia.nix`: GPU drivers and configuration

### Application Configurations
- **Shell**: Fish (primary) with Starship prompt, Zsh (secondary) with modular loading
- **Editor**: Neovim with Lazy.nvim plugin manager, 40+ plugins, AI integration via Avante
- **Terminal**: Multiple options (Ghostty, Alacritty, Kitty) managed via Hyprland
- **Desktop**: Hyprland + HyprPanel on Wayland with automated wallpaper rotation

### Gaming Configuration
- **Steam**: Fully configured with GameMode, GameScope, and MangoHUD integration
- **Panel Behavior**: HyprPanel configured to hide during fullscreen Steam games
- **Scripts**: 
  - `config/scripts/change-resolution`: Switch between gaming and desktop resolutions

## Development Environment

### Language Support
The system includes development tools for:
- Go, Rust, Node.js, Python
- LSP servers, formatters, and debuggers configured in Neovim
- Git with delta/tig/lazygit for version control

### Key Development Scripts
- `config/scripts/tmux-sessionizer`: Project-aware session management
- `config/scripts/hypr-focus-or-run`: Application launcher with focus fallback
- `config/scripts/random-wallpaper`: Automated wallpaper system

## Configuration Management Notes

### Modular Loading
- Zsh configuration uses modular loading from `~/.config/zsh/`
- Neovim plugins are organized in `config/nvim/lua/plugins/`
- The stow script creates necessary directory structure before linking

### Git Integration
- Both `nix-rebuild` and standard git workflows are supported
- Multiple gitconfig files for personal/work separation
- Delta configured for enhanced git diffs

### Hardware Integration
- Nvidia GPU support with proper driver configuration
- Bluetooth, audio (PipeWire), and gaming optimizations
- CPU performance governor and system optimization settings

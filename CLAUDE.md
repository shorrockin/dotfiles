# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Table of Contents

- [Repository Overview](#repository-overview)
- [NixOS Environment Notes](#nixos-environment-notes)
- [Common Commands](#common-commands)
  - [NixOS System Management](#nixos-system-management)
  - [Traditional Dotfile Management](#traditional-dotfile-management)
- [Architecture](#architecture)
  - [Directory Structure](#directory-structure)
  - [Key Configuration Modules](#key-configuration-modules)
  - [Application Configurations](#application-configurations)
- [Common File Patterns](#common-file-patterns)
- [Configuration Management Notes](#configuration-management-notes)
  - [Symlink Management](#symlink-management)
  - [Git Integration](#git-integration)
- [Development Conventions](#development-conventions)

## Repository Overview

This is a **cross-platform dotfiles repository** designed for both NixOS and macOS systems with dual configuration management:

- **NixOS Configuration**: Declarative system configuration using Nix flakes (Linux)
- **Traditional Dotfiles**: GNU Stow-based symlink management (works on both NixOS and macOS)

The repository assumes it's cloned to `~/dotfiles`.

**IMPORTANT**: This configuration supports both NixOS (Linux) and macOS environments. Many configurations are portable across both platforms via the Stow-managed dotfiles.

## NixOS Environment Notes

**Command Locations**: On NixOS, system commands are not in traditional locations (`/bin`, `/usr/bin`). If a command fails to run, use the full path from `/run/current-system/sw/bin/`. For example:
- `/run/current-system/sw/bin/ls`
- `/run/current-system/sw/bin/cat`
- `/run/current-system/sw/bin/grep`

**CRITICAL: Never run `nixos-rebuild` directly** - it requires sudo password input which Claude cannot provide. **ALWAYS instruct the user to run the rebuild command themselves.** Make the necessary config file changes, then explicitly ask the user to run:
```bash
sudo nixos-rebuild switch --flake .#gustave
```

## Common Commands

### NixOS System Management

**Rebuild NixOS system:**
```bash
# User must run manually - Claude cannot execute this
sudo nixos-rebuild switch --flake .#gustave
```

**Expected output (successful):**
```
building the system configuration...
activating the configuration...
setting up /etc...
reloading user units...
setting up tmpfiles
```

**Update flake inputs:**
```bash
nix flake update
```

**Expected output:**
```
warning: updating lock file '/home/username/dotfiles/flake.lock':
• Updated input 'nixpkgs':
    'github:NixOS/nixpkgs/abc123...' (2024-01-15)
  → 'github:NixOS/nixpkgs/def456...' (2024-01-20)
```

**Validation:**
```bash
# Verify flake configuration is valid
nix flake check

# View current system generation
nixos-rebuild list-generations

# Expected output shows generation numbers and dates:
# 1   2024-01-15 10:30:00
# 2   2024-01-20 14:45:00 (current)
```

### Traditional Dotfile Management

**Initial setup - symlinks all dotfiles:**
```bash
config/scripts/dots stow
```

**Expected output (successful):**
```
Stowing dotfiles...
Creating symlinks...
✓ config → ~/.config/
✓ dots → ~/
Done!
```

**Re-link dotfiles (useful after changes):**
```bash
config/scripts/dots restow
```

**Remove all symlinks:**
```bash
config/scripts/dots delete
```

**Expected output:**
```
Removing symlinks...
✓ Removed config symlinks
✓ Removed home dotfile symlinks
Done!
```

**Validation:**
```bash
# Check which files in ~/.config/ are symlinks to dotfiles repo
ls -la ~/.config/ | grep "\->"

# Verify a specific symlink target
readlink ~/.config/fish/config.fish
# Should return: /home/username/dotfiles/config/fish/config.fish

# Check for stow conflicts (dry run before actual stow)
stow -n -d ~/dotfiles -t ~/ dots
stow -n -d ~/dotfiles/config -t ~/.config/ .
```

## Architecture

### Directory Structure

- `flake.nix` + `flake.lock`: Nix flake system definition (NixOS only)
- `hosts/`: Host-specific NixOS configurations (currently `gustave.nix`)
- `modules/`: Modular NixOS configuration components
  - See [Key Configuration Modules](#key-configuration-modules) for details
- `config/`: Application configs that get **symlinked to `~/.config/`** via stow
  - **Important**: Files here are symlinked, not copied. Changes to `~/dotfiles/config/*` appear immediately in `~/.config/`
- `dots/`: Home directory dotfiles that get **symlinked to `~/`** via stow
  - Examples: `.gitconfig`, `.tmux.conf`, etc.

### Key Configuration Modules

These are NixOS-specific modules located in `modules/`:

- `modules/system.nix`: Core system settings and services
- `modules/packages.nix`: System-wide package declarations
- `modules/hyprland.nix`: Wayland compositor setup (see [Application Configurations](#application-configurations))
- `modules/nvidia.nix`: GPU drivers and configuration

### Application Configurations

Core application configurations located in `config/` (symlinked to `~/.config/`):

- **Shell**: Fish (primary) with oh-my-posh prompt
- **Editor**: Neovim with Lazy.nvim plugin manager
  - Plugin configuration: `config/nvim/lua/plugins/`
- **Terminal**: Multiple options (Ghostty, Alacritty, Kitty) managed via Hyprland
- **Desktop**: Hyprland + HyprPanel on Wayland with automated wallpaper rotation
  - Related module: `modules/hyprland.nix`
  - Scripts: `config/scripts/random-wallpaper`, `config/scripts/hypr-focus-or-run`

## Common File Patterns

When making changes, Claude should look for related configurations in these locations:

### Shell Configuration
- Fish: `config/fish/config.fish`, `config/fish/functions/`
- Oh-my-posh: `config/oh-my-posh/`
- Environment variables: `config/fish/conf.d/`

### Editor Configuration
- Neovim core: `config/nvim/init.lua`, `config/nvim/lua/`
- Plugins: `config/nvim/lua/plugins/*.lua`
- LSP config: `config/nvim/lua/plugins/lsp.lua`

### Window Manager / Desktop
- Hyprland: `config/hypr/hyprland.conf`, `modules/hyprland.nix`
- HyprPanel: `config/hyprpanel/`
- Keybindings: `config/hypr/hyprland.conf` (see binds section)

### Custom Scripts
- Location: `config/scripts/`
- Common scripts:
  - `config/scripts/dots`: Stow wrapper for dotfile management

### NixOS System Configuration
- Main flake: `flake.nix`
- Host config: `hosts/gustave.nix`
- Modules: `modules/*.nix`

### Git Configuration
- Main config: `dots/.gitconfig`
- Personal/work separation: `dots/.gitconfig.personal`, etc.

## Configuration Management Notes

### Symlink Management

**Critical Understanding**: The `config/scripts/dots stow` command creates **symbolic links** from this repository to your home directory:

- `~/dotfiles/config/*` → `~/.config/*`
- `~/dotfiles/dots/*` → `~/*`

This means:
- Changes made to files in `~/dotfiles/config/` are **immediately reflected** in `~/.config/`
- You don't need to "re-install" configs after editing them
- If you modify a file through `~/.config/`, you're actually editing the file in `~/dotfiles/config/`

The stow script creates the necessary directory structure before linking to avoid conflicts.

### Git Integration
- NixOS system changes via `nix flake update` and manual `nixos-rebuild` (user-initiated only)
- Standard git workflows for dotfile changes
- Multiple gitconfig files for personal/work separation
- Delta configured for enhanced git diffs

## Development Conventions

### Package Management Patterns
- **Unstable Packages**: The flake injects `pkgs-unstable` into modules via `specialArgs`. Use it in modules like this:
  ```nix
  { config, pkgs, pkgs-unstable, ... }:
  {
    environment.systemPackages = [ pkgs-unstable.some-new-package ];
  }
  ```
- **Home Manager**: **NOT USED**. Do not suggest Home Manager options. All user-level config is handled via:
  1. Traditional dotfiles (Stow) for config files
  2. NixOS `users.users.<name>` for shell/groups
  3. NixOS `environment.systemPackages` (or user packages) for software

### Neovim Configuration Strategy
The `dots` script specifically pre-creates subdirectories for Neovim (`~/.config/nvim/lua`, `plugins`, etc.) *before* stowing.
- **Why**: This allows mixing symlinked public config with private/local files that aren't in the repo across different environments and operating system
- **Implication**: When adding new Neovim directories, ensure they are compatible with this "partial stow" approach.

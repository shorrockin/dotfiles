# nixos/ — NixOS Platform Notes

This directory holds everything NixOS-specific: the flake, the one host
definition (`gustave`), system modules, Home Manager, and the raw-Hyprland
desktop stack (NixOS owns this layer directly, unlike Omarchy which has its
own Lua/Quickshell equivalent — see `../omarchy/CLAUDE.md`). Nothing here is
relevant on macOS or Omarchy.

## Directory Contents

- `flake.nix` / `flake.lock`: Nix flake system definition with Home Manager integration
- `hosts/gustave.nix`: the one NixOS host definition (only host today)
- `modules/`: system-level NixOS configuration components
  - `system.nix`: core system settings and services
  - `packages.nix`: system-level package declarations and program enablement (fish, firefox, steam)
  - `hyprland.nix`: Wayland compositor setup, SDDM display manager, XDG portals
  - `nvidia.nix`: GPU drivers and configuration
  - `hibernate.nix`: NVIDIA suspend/hibernate systemd units
  - `users.nix`: user account, shell, and groups
  - `synology.nix`: NAS SMB mount configuration
  - `bambustudio.nix`: 3D printer slicer AppImage wrapper
  - `hardware-configuration.nix`, `ollama.nix`
- `home/`: Home Manager user-level configuration
  - `default.nix`: main Home Manager entry point
  - `packages.nix`: user-level package declarations (CLI tools, dev languages, editors, GUI apps)
  - `services/random-wallpaper.nix`: systemd user service/timer for wallpaper rotation
  - `services/gtk.nix`: GTK/Qt theming, cursor theme, dconf settings, environment variables
  - `programs/hyprflow.nix`: custom voice-to-text tool built from source
  - `programs/vicinae.nix`
- `config/`: NixOS-only app configs, symlinked to `~/.config/` via `common/config/scripts/dots` (the `nixos` stow root — see repo root `CLAUDE.md` for the stow mechanics): `hypr/`, `hyprpanel/`, `waybar/`, `swaync/`, `wlogout/`, `rofi/`, `walker/`, `vicinae/`, `quickshell/`, `fastfetch/`
  - `hypr/hyprland.conf`: main Hyprland config; keybindings live in this same directory (see `binds.conf`)
  - `scripts/`: Hyprland/NixOS-flavored scripts — `hypr-binds`, `hypr-focus-or-run`, `random-wallpaper`, `wallpaper-fullscreen`, `toggle-tiling`, `toggle-single-window-width`, `change-resolution`, `dictation`

## NixOS Environment Notes

**Command Locations**: system commands are not in traditional locations
(`/bin`, `/usr/bin`). If a command fails to run, use the full path from
`/run/current-system/sw/bin/` — e.g. `/run/current-system/sw/bin/ls`,
`/run/current-system/sw/bin/cat`, `/run/current-system/sw/bin/grep`.

**CRITICAL: Never run `nixos-rebuild` directly** — it requires sudo password
input which Claude cannot provide. **ALWAYS instruct the user to run the
rebuild command themselves.** Make the necessary config file changes, then
explicitly ask the user to run:
```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#gustave
```
(`--flake` accepts a path, so this works from any cwd — no need to `cd` into
`nixos/` first.)

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
nix flake update --flake ~/dotfiles/nixos
```

**Validation:**
```bash
# Verify flake configuration is valid
nix flake check ~/dotfiles/nixos

# View current system generation
nixos-rebuild list-generations

# Check Home Manager status
systemctl --user status home-manager-*

# List Home Manager managed packages
home-manager packages
```

Home Manager is integrated as a NixOS module — a single
`sudo nixos-rebuild switch --flake ~/dotfiles/nixos#gustave` rebuilds both
system and user configuration.

## Package Management Patterns

- **System packages**: add to `modules/packages.nix` — for packages that need
  system-level access or NixOS module enablement (e.g. `programs.steam.enable`)
- **User packages**: add to `home/packages.nix` — for CLI tools, editors, dev
  languages, GUI apps. Managed by Home Manager.
- **Unstable packages**: the flake injects `pkgs-unstable` into both NixOS
  modules and Home Manager via `specialArgs`:
  ```nix
  { config, pkgs, pkgs-unstable, ... }:
  {
    home.packages = [ pkgs-unstable.some-new-package ];
  }
  ```

## Home Manager Usage

1. **User packages** (`home/packages.nix`): all user-installed software
2. **User systemd services** (`home/services/`): wallpaper rotation, theme application
3. **GTK/Qt theming** (`home/services/gtk.nix`): declarative theme, icon, and cursor configuration
4. **Custom packages** (`home/programs/`): packages built from source (e.g. hyprflow)

Application config files (Hyprland, Waybar, Fish, Neovim, etc.) are still
managed via Stow for instant editing without rebuilds — only packages and
services go through Home Manager/Nix.

## Neovim Directory Pre-Creation

`common/config/scripts/dots` pre-creates `~/.config/nvim/{lua,lua/lsp,lua/plugins}`
and `~/.config/nvim/after/{plugin,ftplugin}` before stowing, on every
platform (not just NixOS) — see `../common/CLAUDE.md` for why.

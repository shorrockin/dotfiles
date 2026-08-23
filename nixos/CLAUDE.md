# nixos/ — NixOS platform notes

Flake, the `gustave` host, system modules, Home Manager, and the raw-Hyprland desktop stack (NixOS owns this layer directly; Omarchy has its own Lua/Quickshell equivalent — see `../omarchy/CLAUDE.md`). Nothing here applies on macOS or Omarchy.

## Directory contents

- `flake.nix` / `flake.lock`
- `hosts/gustave.nix` — the one host definition
- `modules/`: `system.nix`, `packages.nix` (system-level packages/enablement, e.g. `programs.steam.enable`), `hyprland.nix` (compositor, SDDM, XDG portals), `nvidia.nix`, `hibernate.nix`, `users.nix`, `synology.nix` (NAS mount), `bambustudio.nix`, `hardware-configuration.nix`, `ollama.nix`
- `home/`: Home Manager — `default.nix`, `packages.nix` (user-level packages), `services/random-wallpaper.nix`, `services/gtk.nix` (GTK/Qt theming, cursor, dconf), `programs/hyprflow.nix` (built from source), `programs/vicinae.nix`
- `config/`: NixOS-only `~/.config` content, stowed via the `nixos` platform root: `hypr/` (main config + `binds.conf`), `hyprpanel/`, `waybar/`, `swaync/`, `wlogout/`, `rofi/`, `walker/`, `vicinae/`, `quickshell/`, `fastfetch/`
  - `scripts/`: `hypr-binds`, `hypr-focus-or-run`, `random-wallpaper`, `wallpaper-fullscreen`, `toggle-tiling`, `toggle-single-window-width`, `change-resolution`, `dictation`

## Environment notes

System commands aren't in `/bin` or `/usr/bin` — use `/run/current-system/sw/bin/<cmd>` if something fails to run.

**Never run `nixos-rebuild` directly** — it needs a sudo password Claude can't provide. Make the config changes, then ask the user to run:
```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#gustave
```
(`--flake` accepts a path, so this works from any cwd.)

```bash
nix flake update --flake ~/dotfiles/nixos     # update inputs
nix flake check ~/dotfiles/nixos              # validate config
nixos-rebuild list-generations
systemctl --user status home-manager-*
home-manager packages
```

## Package management

- System-level access or module enablement (e.g. `programs.steam.enable`) → `modules/packages.nix`
- CLI tools, editors, dev languages, GUI apps → `home/packages.nix` (Home Manager)
- Unstable packages: the flake injects `pkgs-unstable` via `specialArgs` into both:
  ```nix
  { config, pkgs, pkgs-unstable, ... }:
  { home.packages = [ pkgs-unstable.some-new-package ]; }
  ```

Application configs (Hyprland, Waybar, Fish, Neovim, etc.) go through Stow, not Home Manager, so edits apply without a rebuild.

`common/config/scripts/dots` pre-creates `~/.config/nvim/{lua,lua/lsp,lua/plugins}` and `~/.config/nvim/after/{plugin,ftplugin}` before stowing — see `../common/CLAUDE.md`.

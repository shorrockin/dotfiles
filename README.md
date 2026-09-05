# Dotfiles

Personal dotfiles for generic Linux, macOS, NixOS, and Omarchy. Clone the repository to `~/dotfiles` before running a setup.

## Generic Linux

Install GNU Stow with the system package manager, then run:

```bash
common/config/scripts/dots stow
```

## macOS

```bash
brew install stow
common/config/scripts/dots stow
```

## NixOS

Apply the system configuration, then link the application configuration:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#gustave
common/config/scripts/dots stow
```

## Omarchy

Set the machine hostname before running the installer so the matching host configuration is applied.

```bash
omarchy/install.sh
```

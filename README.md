# Dotfiles

This contains dotfiles for Linux, NixOS, macOS, and Omarchy. `common/` holds shared config, while each platform directory defines what ships there. See `CLAUDE.md` for the layout.

Scripts assume the repository is cloned at `~/dotfiles`.

## Stow
This uses [gnu stow](https://www.gnu.org/software/stow/) to symlink dotfiles
into the home directory. You can install it (on macOS) with:
```
> brew install stow
```
Symlink everything applicable to the current platform:
```
> common/config/scripts/dots stow
```
Clean them up with:
```
> common/config/scripts/dots delete
```
Restow with:
```
> common/config/scripts/dots restow
```

`dots` should be on your `PATH` after the first stow (it's inside
`common/config/scripts/`, which gets symlinked to `~/.config/scripts/`), at
which point you shouldn't need to fully qualify it.

## NixOS
```
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#gustave
```
See `nixos/CLAUDE.md` for more (flake update, validation, Home Manager).

## Omarchy
```
omarchy/install.sh
```
See `omarchy/CLAUDE.md` for what it does and the host-profile convention.

## Claude Code
Claude Code is installed via npm (not nixpkgs) for faster access to new releases and working `claude update` support.

Setup (one-time):
```
npm config set prefix ~/.npm-global
npm install -g @anthropic-ai/claude-code
```

Update:
```
claude update
# or: npm update -g @anthropic-ai/claude-code
```

## Quirks
A few other things to note:
- `bat` requires a `bat cache --build`
- `tmux` needs its plugins installed with the tmux-prefix + `I` (capital i) once tpm is cloned
- you can pass `--ignore=<pattern>` to any `stow` invocation to skip specific files

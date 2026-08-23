# macos/ — macOS Platform Notes

Currently the thinnest of the three platform directories — window management
is the only thing that diverges from `common/` on macOS today.

## Directory Contents

- `dots/`: macOS-only home-directory dotfiles, stowed via `--dotfiles`
  (dot-X → .X): `dot-skhdrc` (skhd hotkey daemon), `dot-yabairc` (yabai tiling
  window manager config)
- `config/aerospace/`: Aerospace tiling window manager config
- `config/scripts/`: macOS-flavored scripts — `yabai-focus-or-run`,
  `yabai-highlight-window`, `aerospace-dynamic-gaps.py`, `close-duplicate-tabs`
  (Chrome tab dedup via `osascript`), `kill-apps-for-sleep` (quits
  IntelliJ/Zoom/Camo Studio via `osascript` before sleep)

## Setup

```bash
brew install stow
common/config/scripts/dots stow
```

No bootstrap script exists here yet (unlike `omarchy/install.sh`) — package
installation on macOS is manual/Homebrew today.

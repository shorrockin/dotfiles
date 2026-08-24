# macos/ — macOS platform notes

Thinnest of the three platform directories — window management is the only thing that diverges from `common/` on macOS today.

## Directory contents

- `config/aerospace/`: Aerospace tiling window manager config
- `config/scripts/`: `aerospace-dynamic-gaps.py`, `close-duplicate-tabs` (Chrome tab dedup via `osascript`), `kill-apps-for-sleep` (quits IntelliJ/Zoom/Camo Studio via `osascript` before sleep)

## Setup

```bash
brew install stow
common/config/scripts/dots stow
```

No bootstrap script yet (unlike `omarchy/install.sh`) — package installation is manual via Homebrew.

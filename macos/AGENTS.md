# macos/ — macOS platform notes

macOS uses the shared application configs with a small platform-specific overlay.

## Directory contents

- `config/aerospace/`: Aerospace tiling window manager config
- `config/scripts/`: `aerospace-dynamic-gaps.py`, `close-duplicate-tabs` (Chrome tab dedup via `osascript`), `kill-apps-for-sleep` (quits IntelliJ/Zoom/Camo Studio via `osascript` before sleep)

macOS intentionally does not install personal agent instructions. Those files are owned by the platform roots that opt into them.

## Setup

```bash
brew install stow
common/config/scripts/dots stow
```

No bootstrap script yet (unlike `omarchy/install.sh`) — package installation is manual via Homebrew.

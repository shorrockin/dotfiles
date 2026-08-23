#!/usr/bin/env bash
set -e

echo "(stock config that would conflict — nvim, ghostty, btop, etc. — is backed up automatically as *.pre-stow-backup.<timestamp>)"
"$DOTFILES_DIR/common/config/scripts/dots" stow

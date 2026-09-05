#!/usr/bin/env bash
# Add the shared NAS mount to the Files sidebar.

set -e

BOOKMARKS=~/.config/gtk-3.0/bookmarks
BOOKMARK_LINE="file:///mnt/nas NAS"

mkdir -p "$(dirname "$BOOKMARKS")"
touch "$BOOKMARKS"

if ! grep -qF "file:///mnt/nas" "$BOOKMARKS"; then
  echo "$BOOKMARK_LINE" >> "$BOOKMARKS"
  echo "  Added /mnt/nas to Nautilus bookmarks"
else
  echo "  /mnt/nas already bookmarked in Nautilus"
fi

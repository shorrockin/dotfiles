#!/usr/bin/env bash
#
# Bookmarks the Synology NAS mount (set up by 20-nas-mount.sh) in Nautilus
# (GNOME Files, gustave's default file manager) so it shows in the sidebar.

set -e

BOOKMARKS=~/.config/gtk-3.0/bookmarks
BOOKMARK_LINE="file:///mnt/nas NAS"

mkdir -p "$(dirname "$BOOKMARKS")"
touch "$BOOKMARKS"

if ! grep -qF "file:///mnt/nas" "$BOOKMARKS"; then
  echo "$BOOKMARK_LINE" >> "$BOOKMARKS"
  echo "  Added /mnt/nas to Nautilus bookmarks (restart Nautilus / open Files to see it)"
else
  echo "  /mnt/nas already bookmarked in Nautilus"
fi

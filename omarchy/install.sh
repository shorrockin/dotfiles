#!/usr/bin/env bash
#
# Bootstrap this dotfiles repo on an Omarchy box. Runs each step in
# install.d/ in order — see that directory for what each step does.
#
# Safe to re-run: every step is idempotent.

set -e

export DOTFILES_DIR=~/dotfiles

if [ ! -d /usr/share/omarchy ]; then
  echo "This doesn't look like an Omarchy system (/usr/share/omarchy not found). Aborting." >&2
  exit 1
fi

for step in "$(dirname "$0")"/install.d/*.sh; do
  echo "== $(basename "$step" .sh | sed 's/^[0-9]*-//; s/-/ /g') =="
  "$step"
done

echo "== Done =="
echo "Backed-up stock configs (safe to delete once you've confirmed you don't need them): find ~/.config -name '*.pre-stow-backup.*'"
echo "fish: run 'omarchy restart terminal' or open a new terminal to pick it up."

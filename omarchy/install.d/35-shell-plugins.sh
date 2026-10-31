#!/usr/bin/env bash

set -euo pipefail

PLUGINS_DIR="$HOME/.config/omarchy/plugins"

ensure_plugin() {
  local id="$1"
  local url="$2"
  local target="$PLUGINS_DIR/$id"

  if [ -e "$target" ]; then
    if ! jq -e --arg id "$id" '.id == $id' "$target/manifest.json" >/dev/null 2>&1; then
      echo "Plugin path exists but does not contain the expected $id manifest: $target" >&2
      exit 1
    fi

    echo "  $id already installed."
    return
  fi

  omarchy plugin add "$url" --yes
}

plugin_is_known() {
  local id="$1"

  omarchy plugin list --json 2>/dev/null |
    jq -e --arg id "$id" 'any(.[]; .id == $id)' >/dev/null
}

wait_for_plugin() {
  local id="$1"

  for _ in $(seq 1 40); do
    if plugin_is_known "$id"; then
      return
    fi
    sleep 0.05
  done

  echo "Omarchy shell did not discover plugin $id." >&2
  exit 1
}

ensure_plugin omaplug https://github.com/fross100/omaplug.git
ensure_plugin tornikegomareli.spaces https://github.com/tornikegomareli/omarchy-spaces.git

# Existing installs do not trigger `omarchy plugin add`'s rescan.
omarchy-shell shell rescanPlugins >/dev/null
wait_for_plugin omaplug
wait_for_plugin tornikegomareli.spaces

# Spaces replaces the stock workspace widget, so never leave both enabled.
omarchy plugin disable omarchy.workspaces
omarchy plugin enable tornikegomareli.spaces --after omarchy.menu
omarchy plugin enable omaplug --before omarchy.agents

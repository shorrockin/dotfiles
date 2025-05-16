#!/usr/bin/env bash

# Function to find the next empty workspace
get_next_empty_workspace() {
    used_ids=$(hyprctl workspaces -j | jq '.[].id')
    for i in $(seq 1 20); do
        if ! echo "$used_ids" | grep -q -w "$i"; then
            echo "$i"
            return
        fi
    done
    echo "21"  # fallback
}

# Check if Steam is already running
if pgrep -x "steam" > /dev/null; then
    # Steam is running, focus its window
    steam_win=$(hyprctl clients | awk '/class: steam/ {print $2}')
    if [ -n "$steam_win" ]; then
        hyprctl dispatch focuswindow "$steam_win"
    fi
else
    # Get the next empty workspace
    target_ws=$(get_next_empty_workspace)

    # Switch to it
    hyprctl dispatch workspace "$target_ws"
    sleep 0.2

    # Launch Steam
    steam &

    # Wait until the Steam window appears
    while [ -z "$(hyprctl clients | grep 'class: steam')" ]; do
        sleep 0.5
    done

    # Fullscreen the Steam window
    hyprctl dispatch fullscreen 1
fi


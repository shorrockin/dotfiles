#!/usr/bin/env python3
"""
AeroSpace Dynamic Gaps Script

Adjusts outer gaps based on window count to center content on screen.

Usage: to be invoked by aerospace on any action that could change the layout
of windows. Recommendation:
  on-focus-changed = ['exec-and-forget /path/to/aerospace-dynamic-gaps.py']
  on layout keybinds = ['layout ...', 'exec-and-forget /path/to/aerospace-dynamic-gaps.py']
"""

import json
import os
import re
import subprocess

# Configuration
CONFIG_FILE = os.path.expanduser("~/.aerospace.toml")
MIN_GAP = 10  # Minimum gap to prevent edge-to-edge

# Per-monitor configuration
# Keys are substrings to match against monitor names
# First match wins; "Default" is used if no pattern matches
MONITOR_CONFIGS = {
    "Built-in": {
        "single_window_width": 1500,
        "multi_window_width": 1640,
    },
    "PA34VCNV": {
        "single_window_width": 1680,
        "multi_window_width": 2400,
    },
    "Default": {
        "single_window_width": 1400,
        "multi_window_width": 2600,
    },
}


def get_focused_monitor() -> str:
    """Get the name of the currently focused monitor."""
    try:
        result = subprocess.run(
            ["aerospace", "list-monitors", "--focused",
             "--json", "--format", "%{monitor-name}"],
            capture_output=True,
            text=True,
        )
        monitors = json.loads(result.stdout) if result.stdout.strip() else []
        if monitors:
            return monitors[0].get("monitor-name", "")
    except Exception:
        pass
    return ""


def get_monitor_config(monitor_name: str) -> dict:
    """Get the configuration for a monitor by name."""
    for pattern, config in MONITOR_CONFIGS.items():
        print(pattern, monitor_name)
        if pattern != "Default" and pattern in monitor_name:
            return config
    return MONITOR_CONFIGS["Default"]


def get_monitor_width() -> int:
    """Get effective monitor width using osascript (accounts for DPI scaling)."""
    try:
        result = subprocess.run(
            ["osascript", "-e", 'tell application "Finder" to get bounds of window of desktop'],
            capture_output=True,
            text=True,
        )
        # Output format: "0, 0, 1728, 1117" (left, top, right, bottom)
        parts = result.stdout.strip().split(", ")
        if len(parts) >= 3:
            return int(parts[2])  # right edge = width
    except Exception:
        pass

    # Default fallback
    return 1440


def count_windows() -> int:
    """Count windows on the current workspace.

    Accordion windows are counted as a maximum of 1, since they stack
    and visually occupy the space of a single window.
    """
    try:
        result = subprocess.run(
            ["aerospace", "list-windows", "--workspace", "focused",
             "--json", "--format", "%{window-id} %{window-layout}"],
            capture_output=True,
            text=True,
        )

        windows = json.loads(result.stdout) if result.stdout.strip() else []

        # Treat windows inside an accordion as if they all counted as a
        # single window.
        #
        # NOTE: there is no way given the current list-windows API to
        # differentiate what accordion container a window belongs to,
        # so this would break down in the case of two or more different
        # accordion containers on the same workspace.
        non_accordion_count = 0
        has_accordion = False

        for window in windows:
            layout = window.get("window-layout", "")
            if "accordion" in layout:
                has_accordion = True
            else:
                non_accordion_count += 1

        # Accordion windows count as at most 1
        return non_accordion_count + (1 if has_accordion else 0)
    except Exception:
        return 0


def calculate_gap(monitor_width: int, window_count: int, config: dict) -> int:
    """Calculate the gap size based on window count and monitor config."""
    if window_count <= 0:
        return MIN_GAP
    elif window_count == 1:
        target_width = config["single_window_width"]
    elif window_count == 2:
        target_width = config["multi_window_width"]
    else:
        return MIN_GAP

    # Calculate symmetric gaps: (monitor_width - target_width) / 2
    gap = (monitor_width - target_width) // 2

    return max(gap, MIN_GAP)


def update_config(new_gap: int) -> None:
    """Update the config file with new gap values."""
    if not os.path.exists(CONFIG_FILE):
        return

    with open(CONFIG_FILE, "r") as f:
        content = f.read()

    # Update outer.left and outer.right values
    content = re.sub(
        r"(outer\.left\s*=\s*)\d+",
        rf"\g<1>{new_gap}",
        content,
    )
    content = re.sub(
        r"(outer\.right\s*=\s*)\d+",
        rf"\g<1>{new_gap}",
        content,
    )

    with open(CONFIG_FILE, "w") as f:
        f.write(content)


def reload_config() -> None:
    """Reload AeroSpace configuration."""
    try:
        subprocess.run(["aerospace", "reload-config"], capture_output=True)
    except Exception:
        pass


def main() -> None:
    monitor_name = get_focused_monitor()
    monitor_config = get_monitor_config(monitor_name)
    monitor_width = get_monitor_width()
    window_count = count_windows()
    new_gap = calculate_gap(monitor_width, window_count, monitor_config)

    update_config(new_gap)
    reload_config()


if __name__ == "__main__":
    main()

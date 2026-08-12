#!/usr/bin/env python3
"""
AeroSpace Dynamic Gaps Script

Adjusts ultrawide outer gaps when the focused workspace contains exactly one
tiled window.
"""

import json
import os
import plistlib
import pwd
import re
import socket
import subprocess
import sys
from pathlib import Path
from typing import Any


CONFIG_FILE = Path(os.environ.get("AEROSPACE_CONFIG", "~/.config/aerospace/aerospace.toml")).expanduser()
LOG_FILE = Path(os.environ.get("AEROSPACE_DYNAMIC_GAPS_LOG", "/tmp/aerospace-dynamic-gaps.log"))
MIN_GAP = 10
BASE_GAP = 5
USER_NAME = os.environ.get("USER") or pwd.getpwuid(os.getuid()).pw_name
SOCKET_PATH = Path(f"/tmp/bobko.aerospace-{USER_NAME}.sock")

# First matching monitor-name substring wins. Only enabled monitors get dynamic
# gaps; every other monitor keeps the BASE_GAP fallback in the AeroSpace config.
MONITOR_CONFIGS = {
    "Built-in": {
        "enabled": False,
        "monitor_width": 1512,
    },
    "LG ULTRAWIDE": {
        "enabled": True,
        "monitor_width": 3440,
        "single_window_width": 1920,
    },
    "PA34VCNV": {
        "enabled": True,
        "monitor_width": 3440,
        "single_window_width": 1920,
    },
    "Default": {
        "enabled": False,
        "monitor_width": None,
    },
}

GAP_MONITOR_PATTERN = "LG ULTRAWIDE"


def log(message: str) -> None:
    with LOG_FILE.open("a") as f:
        f.write(f"{message}\n")


def run_aerospace(args: list[str]) -> str:
    """Run an AeroSpace command.

    Prefer the public CLI if it is present. Fall back to the 0.19.x local socket
    protocol because this machine has AeroSpace.app but no Homebrew CLI shim.
    """
    try:
        result = subprocess.run(
            ["aerospace", *args],
            capture_output=True,
            check=False,
            text=True,
        )
        if result.returncode == 0:
            return result.stdout
    except FileNotFoundError:
        pass

    if not SOCKET_PATH.exists():
        raise RuntimeError(f"AEROSPACE SOCKET NOT FOUND: {SOCKET_PATH}")

    request = {
        "command": " ".join(args),
        "args": args,
        "stdin": "",
    }

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.settimeout(5)
        sock.connect(str(SOCKET_PATH))
        sock.sendall(json.dumps(request).encode())
        raw = b""
        while True:
            chunk = sock.recv(1024 * 1024)
            if not chunk:
                raise RuntimeError("AEROSPACE SOCKET CLOSED BEFORE RESPONSE")
            raw += chunk
            try:
                answer = json.loads(raw.decode())
                break
            except json.JSONDecodeError:
                continue

    if answer.get("exitCode") != 0:
        raise RuntimeError(answer.get("stderr") or f"AEROSPACE COMMAND FAILED: {args}")
    return answer.get("stdout", "")


def get_focused_monitor() -> str:
    output = run_aerospace([
        "list-monitors",
        "--focused",
        "--json",
        "--format",
        "%{monitor-name}",
    ])
    monitors = json.loads(output) if output.strip() else []
    if not monitors:
        raise RuntimeError("NO FOCUSED MONITOR")
    return monitors[0].get("monitor-name", "")


def get_monitor_config(monitor_name: str) -> dict[str, Any]:
    for pattern, config in MONITOR_CONFIGS.items():
        if pattern != "Default" and pattern in monitor_name:
            return config
    return MONITOR_CONFIGS["Default"]


def get_display_width_from_windowserver(monitor_name: str) -> int | None:
    """Best-effort fallback for AeroSpace versions that don't expose width."""
    plist_path = Path("/Library/Preferences/com.apple.windowserver.displays.plist")
    if not plist_path.exists():
        return None

    with plist_path.open("rb") as f:
        plist = plistlib.load(f)

    configs = plist.get("DisplayAnyUserSets", {}).get("Configs", [])
    if not configs:
        return None

    displays = configs[0].get("DisplayConfig", [])
    widths = [
        int(display.get("CurrentInfo", {}).get("Wide", 0))
        for display in displays
        if int(display.get("CurrentInfo", {}).get("Wide", 0)) > 0
    ]
    if not widths:
        return None

    if "Built-in" in monitor_name:
        return min(widths)
    return max(widths)


def get_monitor_width(monitor_name: str, config: dict[str, Any]) -> int:
    if config.get("monitor_width"):
        return int(config["monitor_width"])

    width = get_display_width_from_windowserver(monitor_name)
    if width:
        return width

    raise RuntimeError("MONITOR WIDTH NOT FOUND")


def count_windows() -> int:
    output = run_aerospace([
        "list-windows",
        "--workspace",
        "focused",
        "--json",
        "--format",
        "%{window-id} %{window-is-fullscreen}",
    ])
    windows = json.loads(output) if output.strip() else []
    return len([window for window in windows if not window.get("window-is-fullscreen", False)])


def calculate_gap(monitor_width: int, window_count: int, config: dict[str, Any]) -> int:
    if window_count != 1:
        return BASE_GAP

    target_width = int(config["single_window_width"])

    return max((monitor_width - target_width) // 2, MIN_GAP)


def gap_line(key: str, new_gap: int) -> str:
    return f'{key} = [{{ monitor."{GAP_MONITOR_PATTERN}" = {new_gap} }}, {BASE_GAP}]'


def update_config(new_gap: int) -> bool:
    if not CONFIG_FILE.exists():
        raise RuntimeError(f"CONFIG FILE NOT FOUND: {CONFIG_FILE}")

    content = CONFIG_FILE.read_text()
    updated = re.sub(r"^outer\.left\s*=.*$", gap_line("outer.left", new_gap), content, flags=re.MULTILINE)
    updated = re.sub(r"^outer\.right\s*=.*$", gap_line("outer.right", new_gap), updated, flags=re.MULTILINE)

    if updated == content:
        return False

    CONFIG_FILE.write_text(updated)
    return True


def main() -> int:
    try:
        monitor_name = get_focused_monitor()
        monitor_config = get_monitor_config(monitor_name)
        if not monitor_config.get("enabled"):
            return 0

        monitor_width = get_monitor_width(monitor_name, monitor_config)
        window_count = count_windows()
        new_gap = calculate_gap(monitor_width, window_count, monitor_config)

        if update_config(new_gap):
            run_aerospace(["reload-config", "--no-gui"])
        return 0
    except Exception as e:
        log(f"AEROSPACE DYNAMIC GAPS FAILED: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Inject a local Omarchy CSS loader into Slack's Electron archive.

The operation is idempotent and keeps the unmodified archive beside the live
one as app.asar.omarchy-theme-backup. It deliberately refuses unknown archive
layouts instead of guessing.
"""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import shutil
import struct
import sys


DEFAULT_ASAR = Path("/usr/lib/slack/resources/app.asar")
BACKUP_SUFFIX = ".omarchy-theme-backup"
MARKER = b"/* local-omarchy-slack-palette */"
LOADER = MARKER + rb"""
;(() => {
  const { app, webContents } = require("electron");
  const fs = require("fs");
  const path = require("path");
  const os = require("os");
  const cssPath = path.join(os.homedir(), ".local/state/omarchy/current/theme/slack.css");
  const inserted = new WeakMap();

  async function applyTheme(contents) {
    try {
      if (contents.isDestroyed()) return;
      const key = await contents.insertCSS(fs.readFileSync(cssPath, "utf8"), { cssOrigin: "user" });
      const oldKey = inserted.get(contents);
      inserted.set(contents, key);
      if (oldKey) await contents.removeInsertedCSS(oldKey);
    } catch (_) {}
  }

  app.on("web-contents-created", (_event, contents) => {
    contents.on("dom-ready", () => applyTheme(contents));
  });
  fs.watchFile(cssPath, { interval: 1000 }, () => {
    webContents.getAllWebContents().forEach(applyTheme);
  });
})();
"""


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_archive(path: Path) -> tuple[bytearray, dict, bytearray]:
    raw = bytearray(path.read_bytes())
    if len(raw) < 16:
        raise ValueError("archive is too small")

    header_size, pickle_payload_size, json_size = struct.unpack_from("<III", raw, 4)
    if header_size != pickle_payload_size + 4 or json_size > pickle_payload_size - 4:
        raise ValueError("unsupported ASAR header")

    header_end = 16 + json_size
    header = json.loads(bytes(raw[16:header_end]))
    data_start = 8 + header_size
    if data_start > len(raw):
        raise ValueError("ASAR data offset is outside the archive")
    return raw, header, raw[data_start:]


def boot_entry(header: dict) -> dict:
    try:
        entry = header["files"]["dist"]["files"]["boot.bundle.cjs"]
        int(entry["offset"])
        int(entry["size"])
        return entry
    except (KeyError, TypeError, ValueError) as error:
        raise ValueError("Slack boot.bundle.cjs was not found in the expected ASAR layout") from error


def build_archive(header: dict, data: bytearray) -> bytes:
    encoded = json.dumps(header, separators=(",", ":")).encode()
    padding = -len(encoded) % 4
    header_pickle = struct.pack("<II", len(encoded) + padding + 4, len(encoded))
    header_pickle += encoded + (b"\0" * padding)
    return struct.pack("<II", 4, len(header_pickle)) + header_pickle + data


def patch(path: Path) -> bool:
    original, header, data = read_archive(path)
    entry = boot_entry(header)
    start = int(entry["offset"])
    size = int(entry["size"])
    source = bytes(data[start : start + size])
    if len(source) != size:
        raise ValueError("Slack boot bundle points outside the ASAR data")
    if MARKER in source:
        print(f"Slack theme loader is already installed in {path}")
        return False

    patched_source = source + b"\n" + LOADER
    entry["offset"] = str(len(data))
    entry["size"] = len(patched_source)

    integrity = entry.get("integrity")
    if integrity is not None:
        block_size = int(integrity["blockSize"])
        integrity["hash"] = digest(patched_source)
        integrity["blocks"] = [
            digest(patched_source[offset : offset + block_size])
            for offset in range(0, len(patched_source), block_size)
        ]

    data.extend(patched_source)
    patched = build_archive(header, data)
    stat = path.stat()
    backup = Path(f"{path}{BACKUP_SUFFIX}")
    shutil.copy2(path, backup)

    temporary = Path(f"{path}.omarchy-theme-tmp")
    try:
        temporary.write_bytes(patched)
        os.chmod(temporary, stat.st_mode)
        os.chown(temporary, stat.st_uid, stat.st_gid)

        _raw, temporary_header, temporary_data = read_archive(temporary)
        temporary_entry = boot_entry(temporary_header)
        temporary_start = int(temporary_entry["offset"])
        temporary_size = int(temporary_entry["size"])
        if MARKER not in temporary_data[temporary_start : temporary_start + temporary_size]:
            raise RuntimeError("the temporary Slack archive did not verify")

        os.replace(temporary, path)
    finally:
        temporary.unlink(missing_ok=True)

    # Verify the installed archive before reporting success. The untouched
    # backup remains available even if this check raises.
    _raw, installed_header, installed_data = read_archive(path)
    installed_entry = boot_entry(installed_header)
    installed_start = int(installed_entry["offset"])
    installed_size = int(installed_entry["size"])
    installed_source = installed_data[installed_start : installed_start + installed_size]
    if MARKER not in installed_source:
        raise RuntimeError("the Slack archive did not verify after replacement")

    print(f"Installed Slack theme loader; original saved as {backup}")
    return True


def main() -> int:
    path = Path(sys.argv[1]) if len(sys.argv) == 2 else DEFAULT_ASAR
    if not path.is_file():
        print(f"Slack archive not found: {path}", file=sys.stderr)
        return 1
    try:
        patch(path)
    except (OSError, RuntimeError, ValueError, KeyError, TypeError, struct.error, json.JSONDecodeError) as error:
        print(f"Refusing to patch {path}: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

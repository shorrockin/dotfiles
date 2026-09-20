#!/usr/bin/env python3
"""Compare cached Omarchy packages and map changes to local customizations."""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from typing import Any


PACKAGES = ("omarchy", "omarchy-settings")
KINDS = {"preference", "policy", "workaround", "hardware", "integration", "bootstrap"}
PACKAGE_METADATA = {".BUILDINFO", ".MTREE", ".PKGINFO"}


def repository_root(script: Path) -> Path:
    for parent in script.parents:
        if (parent / "omarchy" / "customizations.toml").is_file():
            return parent
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return Path(result.stdout.strip())
    raise RuntimeError("could not locate the dotfiles repository")


def load_inventory(path: Path, repo: Path) -> tuple[dict[str, Any], list[str]]:
    with path.open("rb") as handle:
        inventory = tomllib.load(handle)

    errors: list[str] = []
    if inventory.get("schema_version") != 1:
        errors.append("schema_version must be 1")

    entries = inventory.get("customizations", [])
    seen: set[str] = set()
    for entry in entries:
        entry_id = entry.get("id", "")
        if not entry_id:
            errors.append("every customization needs an id")
        elif entry_id in seen:
            errors.append(f"duplicate customization id: {entry_id}")
        seen.add(entry_id)

        if entry.get("kind") not in KINDS:
            errors.append(f"{entry_id}: invalid kind {entry.get('kind')!r}")
        for field in ("title", "intent"):
            if not entry.get(field):
                errors.append(f"{entry_id}: missing {field}")
        if entry.get("kind") == "workaround" and not entry.get("retire_when"):
            errors.append(f"{entry_id}: workarounds require retire_when")

        implementations = entry.get("implementation", [])
        if not implementations:
            errors.append(f"{entry_id}: missing implementation paths")
        for relative in implementations:
            if not os.path.lexists(repo / relative):
                errors.append(f"{entry_id}: implementation does not exist: {relative}")

        for watch in entry.get("watch", []):
            if ":" not in watch:
                errors.append(f"{entry_id}: watch must be PACKAGE:PATH: {watch}")
                continue
            package, watched_path = watch.split(":", 1)
            if package not in PACKAGES or not watched_path:
                errors.append(f"{entry_id}: invalid watch: {watch}")

    return inventory, errors


def installed_version(package: str) -> str | None:
    result = subprocess.run(
        ["pacman", "-Q", package], check=False, capture_output=True, text=True
    )
    if result.returncode != 0:
        return None
    fields = result.stdout.strip().split(maxsplit=1)
    return fields[1] if len(fields) == 2 else None


def last_upgrade(package: str, log_path: Path, expected_new: str | None) -> tuple[str, str] | None:
    pattern = re.compile(
        rf"\[ALPM\] upgraded {re.escape(package)} \((.+?) -> (.+?)\)$"
    )
    matches: list[tuple[str, str]] = []
    try:
        for line in log_path.read_text(errors="replace").splitlines():
            match = pattern.search(line)
            if match:
                matches.append((match.group(1), match.group(2)))
    except OSError:
        return None
    if expected_new:
        for transition in reversed(matches):
            if transition[1] == expected_new:
                return transition
    return matches[-1] if matches else None


def package_archive(cache: Path, package: str, version: str) -> Path | None:
    candidates = [
        path
        for path in cache.glob(f"{package}-{version}-*.pkg.tar.*")
        if not path.name.endswith(".sig") and path.is_file()
    ]
    return max(candidates, key=lambda path: path.stat().st_mtime) if candidates else None


def extract(archive: Path, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["bsdtar", "-xf", str(archive), "-C", str(destination)],
        check=True,
        stdout=subprocess.DEVNULL,
    )


def digest(path: Path) -> tuple[str, str]:
    if path.is_symlink():
        return ("symlink", os.readlink(path))
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return ("file", hasher.hexdigest())


def snapshot(root: Path) -> dict[str, tuple[str, str]]:
    files: dict[str, tuple[str, str]] = {}
    for path in root.rglob("*"):
        if path.is_symlink() or path.is_file():
            files[path.relative_to(root).as_posix()] = digest(path)
    return files


def compare_package(package: str, old_root: Path, new_root: Path) -> list[dict[str, str]]:
    old = snapshot(old_root)
    new = snapshot(new_root)
    changes: list[dict[str, str]] = []
    for path in sorted(old.keys() | new.keys()):
        if path in PACKAGE_METADATA:
            continue
        if path not in old:
            change = "added"
        elif path not in new:
            change = "removed"
        elif old[path] != new[path]:
            change = "modified"
        else:
            continue
        changes.append({"package": package, "path": path, "change": change})
    return changes


def watch_matches(watch: str, change: dict[str, str]) -> bool:
    package, pattern = watch.split(":", 1)
    if package != change["package"]:
        return False
    path = change["path"]
    if any(character in pattern for character in "*?["):
        return fnmatch.fnmatchcase(path, pattern)
    pattern = pattern.rstrip("/")
    return path == pattern or path.startswith(pattern + "/")


def analyze(inventory: dict[str, Any], changes: list[dict[str, str]]) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []
    for entry in inventory.get("customizations", []):
        matched = [
            change
            for change in changes
            if any(watch_matches(watch, change) for watch in entry.get("watch", []))
        ]
        if matched:
            findings.append(
                {
                    "id": entry["id"],
                    "title": entry["title"],
                    "kind": entry["kind"],
                    "scope": entry.get("scope", "shared"),
                    "intent": entry["intent"],
                    "retire_when": entry.get("retire_when"),
                    "upstream": entry.get("upstream"),
                    "changes": matched,
                }
            )
    return findings


def markdown(report: dict[str, Any]) -> str:
    lines = ["# Omarchy customization audit", "", "## Package transitions", ""]
    for package in PACKAGES:
        transition = report["transitions"].get(package)
        if transition:
            lines.append(f"- `{package}`: `{transition['from']}` → `{transition['to']}`")
        else:
            lines.append(f"- `{package}`: unavailable")

    lines.extend(["", "## Customizations requiring review", ""])
    if not report["findings"]:
        lines.append("No tracked upstream watch paths changed.")
    for finding in report["findings"]:
        lines.extend(
            [
                f"### REVIEW — {finding['title']} (`{finding['id']}`)",
                "",
                f"- Kind: `{finding['kind']}`; scope: `{finding['scope']}`",
                f"- Intent: {finding['intent']}",
            ]
        )
        if finding.get("retire_when"):
            lines.append(f"- Retirement condition: {finding['retire_when']}")
        if finding.get("upstream"):
            lines.append(f"- Upstream reference: {finding['upstream']}")
        lines.append("- Relevant package changes:")
        for change in finding["changes"]:
            lines.append(f"  - `{change['change']}` `{change['package']}:{change['path']}`")
        lines.append("")

    lines.extend(["## New migrations", ""])
    if report["new_migrations"]:
        lines.extend(f"- `{path}`" for path in report["new_migrations"])
    else:
        lines.append("None detected.")

    lines.extend(["", "## Other upstream changes", ""])
    mapped = {
        (change["package"], change["path"], change["change"])
        for finding in report["findings"]
        for change in finding["changes"]
    }
    unmapped = [
        change
        for change in report["changes"]
        if (change["package"], change["path"], change["change"]) not in mapped
    ]
    for change in unmapped[:250]:
        lines.append(f"- `{change['change']}` `{change['package']}:{change['path']}`")
    if len(unmapped) > 250:
        lines.append(f"- … {len(unmapped) - 250} more; use `--format json` for the full list")
    if not unmapped:
        lines.append("None.")

    if report["warnings"]:
        lines.extend(["", "## Warnings", ""])
        lines.extend(f"- {warning}" for warning in report["warnings"])
    lines.append("")
    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", type=Path)
    parser.add_argument("--cache-dir", type=Path, default=Path("/var/cache/pacman/pkg"))
    parser.add_argument("--pacman-log", type=Path, default=Path("/var/log/pacman.log"))
    parser.add_argument("--from-version", help="override the old version for both packages")
    parser.add_argument("--to-version", help="override the new version for both packages")
    parser.add_argument("--format", choices=("markdown", "json"), default="markdown")
    parser.add_argument("--validate", action="store_true", help="validate only; do not compare packages")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        repo = repository_root(Path(__file__).resolve())
        inventory_path = args.inventory or repo / "omarchy" / "customizations.toml"
        inventory, errors = load_inventory(inventory_path, repo)
    except (OSError, RuntimeError, tomllib.TOMLDecodeError) as error:
        print(f"omarchy-upgrade-audit: {error}", file=sys.stderr)
        return 2

    if errors:
        print("Inventory validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 2
    if args.validate:
        print(f"Inventory is valid: {len(inventory.get('customizations', []))} customizations")
        return 0

    warnings: list[str] = []
    transitions: dict[str, dict[str, str]] = {}
    archives: dict[str, tuple[Path, Path]] = {}
    for package in PACKAGES:
        current = installed_version(package)
        transition = last_upgrade(package, args.pacman_log, args.to_version or current)
        old_version = args.from_version or (transition[0] if transition else None)
        new_version = args.to_version or (transition[1] if transition else current)
        if not old_version or not new_version:
            warnings.append(f"could not determine the version transition for {package}")
            continue
        transitions[package] = {"from": old_version, "to": new_version}
        old_archive = package_archive(args.cache_dir, package, old_version)
        new_archive = package_archive(args.cache_dir, package, new_version)
        if not old_archive or not new_archive:
            missing = old_version if not old_archive else new_version
            warnings.append(f"cached {package} package not found for version {missing}")
            continue
        archives[package] = (old_archive, new_archive)

    changes: list[dict[str, str]] = []
    if archives:
        if not shutil.which("bsdtar"):
            print("omarchy-upgrade-audit: bsdtar is required", file=sys.stderr)
            return 2
        with tempfile.TemporaryDirectory(prefix="omarchy-upgrade-audit-") as temporary:
            temp = Path(temporary)
            for package, (old_archive, new_archive) in archives.items():
                old_root = temp / package / "old"
                new_root = temp / package / "new"
                try:
                    extract(old_archive, old_root)
                    extract(new_archive, new_root)
                except subprocess.CalledProcessError as error:
                    warnings.append(f"failed to extract {package}: {error}")
                    continue
                changes.extend(compare_package(package, old_root, new_root))

    findings = analyze(inventory, changes)
    new_migrations = sorted(
        change["path"]
        for change in changes
        if change["change"] == "added"
        and change["path"].startswith("usr/share/omarchy/migrations/")
        and change["path"].endswith(".sh")
    )
    report = {
        "inventory": str(inventory_path),
        "transitions": transitions,
        "findings": findings,
        "new_migrations": new_migrations,
        "changes": changes,
        "warnings": warnings,
    }
    if args.format == "json":
        json.dump(report, sys.stdout, indent=2)
        print()
    else:
        print(markdown(report), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

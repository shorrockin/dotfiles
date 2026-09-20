---
name: omarchy-upgrade-audit
description: Audit an Omarchy package upgrade against the tracked local customization inventory. Use after an Omarchy upgrade, when reviewing upgrade compatibility or obsolete workarounds, or when maintaining omarchy/customizations.toml. Do not use for an ordinary customization unless its inventory entry also needs to change.
---

# Omarchy Upgrade Audit

Review an Omarchy upgrade without changing the live system or automatically
removing customizations.

## Source of truth

The repository's `omarchy/customizations.toml` records why each customization
exists, its implementation files, upstream paths that can affect it, and the
condition under which a workaround can be retired. Treat that inventory as part
of the customization itself:

- Add an entry when adding a new Omarchy-specific preference, policy,
  integration, hardware adaptation, or workaround.
- Update the entry when its behavior, implementation paths, upstream
  dependencies, or retirement condition changes.
- Remove an entry only in the same change that removes its implementation.
- Group files by one user-visible intent; do not create one entry per file.

## Run an audit

1. Locate the repository root and inventory. On this setup they are
   `~/dotfiles` and `~/dotfiles/omarchy/customizations.toml`.
2. Run `scripts/audit.py` from this skill. It reads pacman's log, extracts the
   cached before/after `omarchy` and `omarchy-settings` packages into a
   temporary directory, and maps changed package paths to inventory watches.
   It never edits `/usr/share/omarchy`.
3. Inspect every flagged customization, the exact upstream diff, and new
   migrations. Read the current installed upstream files when useful.
4. Search upstream release notes, commits, or issues only when the package diff
   and local evidence cannot answer whether the intent is now supported.
5. Report one decision for each flagged customization:
   - **KEEP**: still intentional or still required.
   - **REVIEW**: related upstream behavior changed, but runtime validation or a
     user decision is needed.
   - **RETIRE CANDIDATE**: the recorded `retire_when` condition appears true;
     explain the evidence and validation needed before removal.
   - **CONFLICT**: the customization is incompatible with the new upstream
     behavior or was overwritten/broken.
6. Do not remove, rewrite, or reapply a customization unless the user asks.

Run the installed helper directly when convenient:

```bash
omarchy-upgrade-audit
omarchy-upgrade-audit --format json
omarchy-upgrade-audit --validate
```

If automatic version discovery fails, pass the versions found in the pacman
log with `--from-version` and `--to-version`. Missing cached packages are a
real limitation: report it rather than comparing the live tree to itself.

## Interpret categories correctly

- `preference` and `policy` entries are not obsolete merely because upstream
  changed. Check for conflicts while preserving the user's choice.
- `workaround` entries can become retirement candidates, but only when their
  explicit `retire_when` condition is supported by evidence.
- `hardware` entries require validation on the named host; generic upstream
  support is not sufficient proof.
- `integration` and `bootstrap` entries primarily need API, path, package, and
  lifecycle compatibility review.

The post-update hook writes a deterministic report under
`~/.local/state/omarchy-upgrade-audit/`. It deliberately exits successfully
even when report generation fails so an audit cannot break `omarchy update`.

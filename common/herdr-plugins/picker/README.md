# Workspace picker for Herdr

Open a popup and start typing to fuzzy-search workspace names across the current
Herdr server and its enabled saved SSH machines. Each result includes its machine.
Tabs, panes, working directories, and machine names do not affect matching.
Results arrive as machines respond, so a slow SSH connection does not delay local
search. Each remote request has an eight-second deadline. Nothing is cached on disk.

## Install

Requires Herdr 0.9.0+, Node.js 22+, fzf 0.60+, and OpenSSH. On macOS, install fzf
with `brew install fzf`. There are no npm dependencies or build steps.

```sh
herdr plugin link ~/dotfiles/common/herdr-plugins/picker
```

Add this to `~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "ctrl+s"
type = "plugin_action"
command = "shorrock.picker.open"
description = "find a workspace"
```

In the existing `[keys]` table, move `goto` off Ctrl+S so the bindings do not
conflict. Keep it available as the fallback for cross-machine navigation:

```toml
goto = ["prefix+g", "ctrl+shift+s"]
```

Run `herdr config check` and `herdr server reload-config`. With saved machines,
also use Herdr's **reload config** UI action to refresh client bindings.

## Controls

| Key | Action |
| --- | --- |
| Type | Fuzzy-search workspace names |
| Up/Down or Ctrl+P/N | Select a result |
| Enter | Focus a workspace on the current server, or show remote details |
| Ctrl+R | Refresh all machines, keeping the query |
| Ctrl+E | Show connection results and errors |
| Esc | Close the picker, or return from details to search |

## Cross-machine limits

Herdr 0.9.0 plugins run on the selected server. This plugin reads that server's
saved-machine catalog, not the client sidebar's live connection cache. Install
and open it on **Local** to search the machines saved on your Mac. When viewing
a remote machine, a plugin installed only on Local is unavailable; use the global
navigator to return to Local first. A remote installation would read that host's
own catalog instead.

Remote selection shows the exact workspace and machine to choose in the sidebar
or global navigator. It does not change remote focus. Herdr currently exposes no
plugin API to activate a different machine in the attached client. Local selection
uses `workspace focus` and closes the popup.

The picker queries enabled profiles using noninteractive SSH and each profile's
saved session. An SSH-reachable machine can appear even if Herdr's sidebar connection
is unavailable. Failed connections appear in the header and Ctrl+E details. The
plugin never installs Herdr remotely, starts remote sessions, or changes profiles.

## Development

```sh
npm test
node bin/picker.mjs list
node bin/picker.mjs browse
```

`list` is read-only and includes per-machine errors. It exits with status 1 if any
machine could not be queried. The tests cover routing, partial SSH failures,
workspace identity, and fuzzy matching through the installed fzf binary.

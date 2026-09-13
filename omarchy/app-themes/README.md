# Omarchy application palettes

`install.d/49-app-themes.sh` extends Omarchy's palette to Slack, Steam, and WhatsApp
without downloading or executing third-party theme projects.

## Steam

The installer installs the open-source Millennium framework from the AUR, then
copies the local CSS-only theme in `steam/` to
`~/.steam/steam/millennium/themes/omarchy`. It preserves Millennium's other
settings while selecting that theme in `~/.config/millennium/config.json`.

The theme contains no JavaScript, plugins, remote resources, or update metadata.
Omarchy's theme hook republishes `omarchy.css` after each palette change. If a
Steam window is open, the hook also uses Millennium's local URL protocol to
soft-reload the stylesheet; otherwise the new palette loads the next time Steam
opens. A full Steam restart is only needed after Millennium is first installed.

Millennium itself is a native third-party dependency with the same access as
Steam. Its Arch package bootstraps by replacing Steam's 32-bit and 64-bit
`libXtst.so.6` links with Millennium loader links; removing the package removes
those links. This integration trusts that package, but does not trust or install
anything from Millennium's theme or plugin marketplace.

## WhatsApp

The installer copies the extension in `whatsapp/extension/` to
`~/.local/share/omarchy-app-themes/whatsapp` and adds that path to the existing
`--load-extension` browser flag. The extension runs only on
`https://web.whatsapp.com/`, has no permissions, and reads only its bundled
`theme.css`. The theme hook republishes that file from Omarchy's generated
`whatsapp.css` template after every theme change.

Omarchy's stock WhatsApp Slim extension remains enabled. It selects WhatsApp's
system light/dark mode and improves narrow layouts; this extension only adds
the active palette.

## Slack

Slack does not expose a supported custom-CSS mechanism. The installer therefore
adds a small local CSS loader to Slack's Electron `app.asar`, while keeping the
unmodified archive as:

```text
/usr/lib/slack/resources/app.asar.omarchy-theme-backup
```

The patcher validates the expected archive structure, preserves ownership and
mode, replaces the archive atomically, verifies the result, and exits without
changing an archive it does not understand. A root-owned pacman hook reapplies
the patch after Slack upgrades.

To restore stock Slack, copy the backup over `app.asar`, then remove
`/etc/pacman.d/hooks/omarchy-slack-theme.hook` and
`/usr/local/bin/omarchy-slack-theme-patch` as root.

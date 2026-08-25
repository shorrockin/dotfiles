-- Personal Hyprland overrides for Omarchy boxes.
--
-- Loaded from ~/.config/hypr/hyprland.lua via `require("hypr.overrides")`,
-- after Omarchy's defaults and after monitors/input/bindings/looknfeel/autostart.
-- Everything else in ~/.config/hypr (bindings.lua, monitors.lua, etc.) is left
-- as Omarchy's own local, untracked config — this is the one file from that
-- directory that's actually version-controlled.

-- Kinesis 360 keyboard has MINUS and EQUAL swapped relative to a standard
-- layout, so Omarchy's default resize bindings (tiling.lua) feel backwards.
-- Swap what each key does across every modifier variant (plain, SHIFT, ALT,
-- CTRL, and their combinations) so the scheme stays internally consistent.
hl.unbind("SUPER + code:20")
hl.unbind("SUPER + code:21")
hl.unbind("SUPER + SHIFT + code:20")
hl.unbind("SUPER + SHIFT + code:21")
hl.unbind("SUPER + ALT + code:20")
hl.unbind("SUPER + ALT + code:21")
hl.unbind("SUPER + SHIFT + ALT + code:20")
hl.unbind("SUPER + SHIFT + ALT + code:21")
hl.unbind("SUPER + CTRL + code:20")
hl.unbind("SUPER + CTRL + code:21")
hl.unbind("SUPER + CTRL + SHIFT + code:20")
hl.unbind("SUPER + CTRL + SHIFT + code:21")

o.bind("SUPER + code:21", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + code:20", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + code:21", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + SHIFT + code:20", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

o.bind("SUPER + ALT + code:21", "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
o.bind("SUPER + ALT + code:20", "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:21", "Shrink window up a little", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:20", "Expand window down a little", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

o.bind("SUPER + CTRL + code:21", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
o.bind("SUPER + CTRL + code:20", "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:21", "Shrink window up a lot", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:20", "Expand window down a lot", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))

-- Controller input (Steam Input) is read directly via evdev/uinput and never
-- reaches Wayland, so Hyprland's idle timer keeps counting during gameplay
-- and the screensaver/lock can fire mid-game. Proton titles all share the
-- steam_app_<appid> window class, so inhibit idle for any of them.
o.window({ class = "^steam_app_" }, { idle_inhibit = "always" })

-- Native Linux Steam builds don't get the steam_app_<appid> class rename --
-- that's Steam's Xwayland/Proton-specific behavior -- so there's no fixed
-- class to match across arbitrary native titles. Fall back to inhibiting
-- idle for any fullscreen window instead, which covers native games (almost
-- always played fullscreen) without needing to know their class up front.
o.window({ class = ".*" }, { idle_inhibit = "fullscreen" })

-- Omarchy's default steam.lua floats the whole "steam" class, which also
-- covers friend-message/achievement toast popups (same class, different
-- title) -- those should stay floating. Tile only the main window and
-- Friends List by title; this loads after that default rule, and an
-- explicit `tile` rule is what overrides a broader `float` match.
o.window({ class = "steam", title = "Steam" }, { tile = true })
o.window({ class = "steam", title = "Friends List" }, { tile = true })

-- Power button: suspend immediately instead of opening the power menu.
-- Was bound to "Power menu" (omarchy-menu toggle system) by Omarchy's
-- default utilities.lua; unbind before overriding since it's locked.
hl.unbind("XF86PowerOff")
o.bind("XF86PowerOff", "Suspend", "systemctl suspend", { locked = true })

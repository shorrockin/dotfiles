-- Personal Hyprland overrides for Omarchy boxes.
--
-- Loaded from ~/.config/hypr/hyprland.lua via `require("hypr.overrides")`,
-- after Omarchy's defaults and after monitors/input/bindings/looknfeel/autostart.
-- Everything else in ~/.config/hypr (bindings.lua, monitors.lua, etc.) is left
-- as Omarchy's own local, untracked config — this is the one file from that
-- directory that's actually version-controlled.

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

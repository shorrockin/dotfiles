-- Personal Hyprland overrides for Omarchy boxes.
--
-- Loaded from ~/.config/hypr/hyprland.lua via `require("hypr.overrides")`,
-- after Omarchy's defaults and after monitors/input/bindings/looknfeel/autostart.
-- Everything else in ~/.config/hypr (bindings.lua, monitors.lua, etc.) is left
-- as Omarchy's own local, untracked config — this is the one file from that
-- directory that's actually version-controlled.

-- Use the niri-like side-scrolling layout by default on every workspace.
hl.config({
  general = {
    layout = "scrolling",
  },
})

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

-- Omarchy's screensaver is also fullscreen, but it must not inherit the game
-- rule above or it prevents hypridle's later suspend timeout from ever firing.
o.window({ class = "^org\\.omarchy\\.screensaver$" }, { idle_inhibit = "none" })

-- Hyprland always draws pinned windows above the workspace, including above
-- the fullscreen screensaver. Temporarily unpin them while the screensaver is
-- visible, then restore both their pin and stacking order when it closes.
--
-- This mirrors the upstream Omarchy fix from PR #7876. Keep it here until that
-- change ships, then remove this block so Omarchy owns the behavior again.
local screensaver_class = "org.omarchy.screensaver"
local screensaver_unpinned_tag = "omarchy-screensaver-unpinned"

local function set_window_pin(window, action)
  hl.dispatch(hl.dsp.window.pin({ action = action, window = window }))
end

local function set_window_tag(window, tag)
  hl.dispatch(hl.dsp.window.tag({ tag = tag, window = window }))
end

local function set_window_zorder(window, mode)
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = mode, window = window }))
end

local function screensaver_windows()
  return hl.get_windows({ class = screensaver_class })
end

local function screensaver_unpinned_windows()
  return hl.get_windows({ tag = screensaver_unpinned_tag })
end

local function unpin_for_screensaver(window)
  set_window_tag(window, "+" .. screensaver_unpinned_tag)
  set_window_pin(window, "off")
end

local function unpin_pinned_windows_for_screensaver()
  for _, window in ipairs(hl.get_windows()) do
    if window.pinned and window.class ~= screensaver_class then
      unpin_for_screensaver(window)
    end
  end
end

local function lower_screensaver_unpinned_windows()
  for _, window in ipairs(screensaver_unpinned_windows()) do
    if window.allowed_over_fullscreen then
      set_window_zorder(window, "bottom")
    end
  end
end

local function restore_screensaver_pins()
  -- hl.get_windows returns bottom-to-top order. Raising in that same order
  -- restores the windows' original stacking order.
  for _, window in ipairs(screensaver_unpinned_windows()) do
    set_window_zorder(window, "top")
    set_window_pin(window, "on")

    -- Hyprland refuses to pin fullscreen windows. Leave those tagged so a
    -- later fullscreen event can retry the restoration.
    if window.pinned then
      set_window_tag(window, "-" .. screensaver_unpinned_tag)
    end
  end
end

local function restore_screensaver_pins_if_gone()
  if #screensaver_unpinned_windows() > 0 and #screensaver_windows() == 0 then
    restore_screensaver_pins()
  end
end

-- Unpin before the screensaver becomes fullscreen; after that point Hyprland
-- skips pinned windows while hiding the workspace beneath it.
hl.on("window.open_early", function(window)
  if window.class == screensaver_class then
    unpin_pinned_windows_for_screensaver()
  end
end)

hl.on("window.open", function(window)
  if window.class == screensaver_class then
    unpin_pinned_windows_for_screensaver()
    lower_screensaver_unpinned_windows()
  elseif window.pinned and #screensaver_windows() > 0 then
    unpin_for_screensaver(window)
    lower_screensaver_unpinned_windows()
  end
end)

hl.on("window.pin", function(window)
  if window.pinned and window.class ~= screensaver_class and #screensaver_windows() > 0 then
    unpin_for_screensaver(window)
    lower_screensaver_unpinned_windows()
  end
end)

hl.on("window.close", restore_screensaver_pins_if_gone)
hl.on("window.destroy", restore_screensaver_pins_if_gone)
hl.on("config.reloaded", restore_screensaver_pins_if_gone)
hl.on("window.fullscreen", restore_screensaver_pins_if_gone)

-- Omarchy's default steam.lua floats the whole "steam" class, which also
-- covers friend-message/achievement toast popups (same class, different
-- title) -- those should stay floating. Tile only the main window and
-- Friends List by title; this loads after that default rule, and an
-- explicit `tile` rule is what overrides a broader `float` match.
o.window({ class = "steam", title = "Steam" }, { tile = true })
o.window({ class = "steam", title = "Friends List" }, { tile = true })

-- Keep unmodified mouse side buttons available to applications and games.
o.bind("SUPER + mouse:275", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + mouse:276", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))

-- Power button: suspend immediately instead of opening the power menu.
-- Was bound to "Power menu" (omarchy-menu toggle system) by Omarchy's
-- default utilities.lua; unbind before overriding since it's locked.
hl.unbind("XF86PowerOff")
o.bind("XF86PowerOff", "Suspend", "systemctl suspend", { locked = true })

-- Load a machine-specific layer when the host profile provides one. Check for
-- the file first so a real error inside it still reaches Hyprland.
local host_override_path = os.getenv("HOME") .. "/.config/hypr/host.lua"
local host_override = io.open(host_override_path, "r")
if host_override then
  host_override:close()
  require("hypr.host")
end

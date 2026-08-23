-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- gustave override: Omarchy's stock default sets GDK_SCALE=2, meant for a
-- HiDPI panel. This box's only display is a standard-DPI LG UltraWide
-- (3440x1440 @ 800x340mm, ~108 PPI, Hyprland already reports scale: 1), so
-- GDK_SCALE=2 makes every GTK-backed app (Bambu Studio via wxWidgets, older
-- Steam UI, etc.) render at 2x too large. Set to 1 to match the real display.

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

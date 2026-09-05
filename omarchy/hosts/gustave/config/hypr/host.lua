-- Gustave-only Hyprland settings.

-- Kinesis 360 has MINUS and EQUAL swapped relative to a standard keyboard.
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

-- Gustave's launch-or-focus shortcuts.
o.bind("SUPER + ALT + A", "ChatGPT", { launch = "chatgpt", focus = "^Chatgpt$" })
o.bind("SUPER + ALT + T", "Steam", { launch = "steam", focus = "steam" })
o.bind("SUPER + ALT + L", "Slack", { launch = "slack", focus = "slack" })
o.bind("SUPER + ALT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + ALT + Y", "YouTube", { webapp = "https://youtube.com/", focus = true })
o.bind("SUPER + ALT + D", "Discord", { webapp = "https://discord.com/channels/@me", focus = true })
o.bind("SUPER + ALT + Z", "Zoom", { launch = "omarchy-webapp-handler-zoom", focus = "zoom" })

hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "ChatGPT", { launch = "chatgpt" })

o.bind("SUPER + ALT + B", "Browser", "omarchy-launch-or-focus brave omarchy-launch-browser")

-- SUPER+ALT+G is stock "Move active window out of group".
hl.unbind("SUPER + ALT + G")
o.bind("SUPER + ALT + G", "Ghostty", { launch = "ghostty --gtk-single-instance=true", focus = "ghostty" })

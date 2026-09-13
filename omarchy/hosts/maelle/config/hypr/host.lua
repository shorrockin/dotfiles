-- Maelle-specific Hyprland input overrides.
-- Make Caps Lock act as Escape instead of Omarchy's default Compose key.
hl.config({
  input = {
    kb_options = "caps:escape",
  },
})

-- Override Omarchy's ChatGPT web app with the installed native desktop app.
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "ChatGPT", { launch = "chatgpt" })

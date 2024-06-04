-- documents some key-binds that i often forget such that
-- i can search telescope and rediscover their keybindings
local document = function(keys, desc, mode)
	mode = mode or "n"
	vim.api.nvim_set_keymap(mode, keys, keys, { noremap = true, silent = true, desc = desc })
end

document("J", "Join lines")

document("za", "Toggle Fold")
document("zM", "Close all folds")
document("zR", "Open all folds")
document("zA", "Open/closs all folds recursively")

--document("gx", "[G]oto E[x]ternal URL/Other under cursor")
document("gf", "[G]oto [F]ile at cursor in vim")

document("gg", "[G]oto top of file")
document("G", "[G]oto bottom of file")
document("gj", "[G]oto next visual line)")
document("gk", "[G]oto previous visual line")
document("g0", "[G]oto first character of visual line")
document("g^", "[G]oto first non-blank character of visual line")
document("g$", "[G]oto end of visual line")
document("gv", "[G]oto and select last [v]isual selection")

document("~", "Toggle case for single letter")
document("g~", "Toggle case on motion")
document("gu", "Convert to lowercase")
document("gU", "Convert to uppercase")

document("g&", "Reruns the last substitue command across the file")

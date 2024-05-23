-- documents some key-binds that i often forget such that
-- i can search telescope and rediscover their keybindings
local document = function(keys, desc, mode)
	mode = mode or "n"
	vim.api.nvim_set_keymap(mode, keys, keys, { noremap = true, silent = true, desc = desc })
end

document("za", "Toggle Fold")
document("zM", "Close all folds")
document("zR", "Open all folds")
document("zA", "Open/closs all folds recursively")

document("gx", "[G]oto URL under cursor in browser")

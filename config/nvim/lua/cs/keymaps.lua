local map = function(keys, func, desc, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keys, func, { desc = "Keymap: " .. desc })
end

-- leader key to space
vim.g.mapleader = " "

-- simple write file, slightly faster
map("<leader>w", vim.cmd.write, "[w]rite")

-- half page jumping keeps cursor in the middle, less dissorienting
map("<C-d>", "<C-d>zz", "Page [d]own")
map("<C-u>", "<C-u>zz", "Page [u]p")

-- similar to above, searching keeps terms in the middle of the screen
map("n", "nzzzv", "[n]ext")
map("N", "Nzzzv", "Previous")

-- yank into the system clipboard
map("<leader>y", [["+y]], "[y]ank To System Clipboard", { "n", "v" })
map("<leader>Y", [["+Y]], "[Y]ank To System Clipboard")
map("<leader>crp", ":let @+=expand('%')<CR>", "[c]opy [r]elative [p]ath To System Clipboard")

-- set up our leader keys to split horizontally and vertically, similar to tmux
map("<leader>-", "<c-w>s", "horizontal split")
map("<leader>_", "<c-w>v", "vertical split")

-- easy navigation of quick suggestions
map("<leader>qn", "<cmd>cnext<CR>zz", "[q]uickfix [n]ext")
map("<leader>qp", "<cmd>cprev<CR>zz", "[q]uickfix [p]revious")
map("<leader>k", "<cmd>lnext<CR>zz", "Location List Next")
map("<leader>j", "<cmd>lprev<CR>zz", "Location List Previous")

-- binds re-source as leader-so
-- doesn't work, maybe :so % would be a better binding, but also maybe unecessary
-- map("<leader>so", vim.cmd.source, "[S]ource [O]ptions")

-- effectively a rename, changes the word you were on with
map("<leader>sc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[s]ubstitute [c]urrent word")

-- makes the current file executable
map("<leader>mx", "<cmd>!chmod +x %<CR>", "[m]ake File E[x]ecutable")

-- toggles spell check on/off
map("<leader>ts", function()
	local current_spell_setting = vim.opt.spell:get()
	vim.opt.spell = not current_spell_setting
end, "[t]oggle [s]pell")

-- toggles line wrapping on/off
map("<leader>tw", function()
	local current_wrap = vim.opt.wrap:get()
	vim.opt.wrap = not current_wrap
end, "[t]oggle Line [w]rap")

-- allows you to select a bunch of text and move it around uing J and K
map("J", ":m '>+1<CR>gv=gv", "Move Selection Down", "v")
map("K", ":m '<-2<CR>gv=gv", "Move Selection Up", "v")

-- allows for pasting overtop off things from whatever is in your register,
-- while maintaining the contents on that register
map("<leader>p", [['_dP]], "Paste Over Selection", "x")

-- closes the current buffer, and window, and opens the previous buffer
map("<leader>q", "<cmd>bp<bar>bd #<CR>", "[q]uit Buffer")
map("<leader>n", "<cmd>bn<CR>", "[n]ext Buffer")
map("<leader>p", "<cmd>bp<CR>", "[p]revious Buffer")
map("<leader>P", "<cmd>b#<CR>", "[P]revious Buffer Opened")

-- disables arrow keys in normal mode, form better habits
-- disabled in favor of delaytrain for now. perhaps more useful?
-- map("<left>", '<cmd>echo "Use h to move!!"<CR>', "<left> Arrow Key Warning")
-- map("<right>", '<cmd>echo "Use l to move!!"<CR>', "<right> Arrow Key Warning")
-- map("<up>", '<cmd>echo "Use k to move!!"<CR>', "<up> Arrow Key Warning")
-- map("<down>", '<cmd>echo "Use j to move!!"<CR>', "<down> Arrow Key Warning")

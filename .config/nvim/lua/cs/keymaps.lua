local map = function(keys, func, desc, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keys, func, { desc = "Keymap: " .. desc })
end

-- leader key to space
vim.g.mapleader = " "

-- simple write file, slightly faster
map("<leader>w", vim.cmd.write, "[W]rite")

-- half page jumping keeps cursor in the middle, less dissorienting
map("<C-d>", "<C-d>zz", "Page [D]own")
map("<C-u>", "<C-u>zz", "Page [U]p")

-- similar to above, searching keeps terms in the middle of the screen
map("n", "nzzzv", "[N]ext")
map("N", "Nzzzv", "Previous")

-- yank into the system clipboard
map("<leader>y", [["+y]], "[Y]ank To System Clipboard", { "n", "v" })
map("<leader>Y", [["+Y]], "[Y]ank To System Clipboard")
map("<leader>crp", ":let @+=expand('%')<CR>", "[C]opy [R]elative [P]ath To System Clipboard")

-- set up our leader keys to split horizontally and vertically, similar to tmux
map("<leader>-", "<c-w>s", "[h]orizontal split")
map("<leader>_", "<c-w>v", "[v]ertical split")

-- easy navigation of quick suggestions
map("<leader>qn", "<cmd>cnext<CR>zz", "[Q]uickfix [N]ext")
map("<leader>qp", "<cmd>cprev<CR>zz", "[Q]uickfix [P]revious")
map("<leader>k", "<cmd>lnext<CR>zz", "Location List Next")
map("<leader>j", "<cmd>lprev<CR>zz", "Location List Previous")

-- binds re-source as leader-so
map("<leader>so", vim.cmd.source, "[S]ource [O]ptions")

-- effectively a rename, changes the word you were on with
map("<leader>sc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[S]ubstitute [c]urrent word")

-- makes the current file executable
map("<leader>mx", "<cmd>!chmod +x %<CR>", "[M]ake File E[x]ecutable")

-- toggles spell check on/off
map("<leader>ts", function()
	vim.opt.spell = not (vim.opt.spell:get())
end, "[T]oggle [S]pell")

-- allows you to select a bunch of text and move it around uing J and K
map("J", ":m '>+1<CR>gv=gv", "Move Selection Down", "v")
map("K", ":m '<-2<CR>gv=gv", "Move Selection Up", "v")

-- allows for pasting overtop off things from whatever is in your register,
-- while maintaining the contents on that register
map("<leader>p", [['_dP]], "Paste Over Selection", "x")

-- closes the current buffer, and window, and opens the previous buffer
map("<leader>q", "<cmd>bp<bar>bd #<CR>", "[Q]uit Buffer")
map("<leader>n", "<cmd>bn<CR>", "[N]ext Buffer")
map("<leader>p", "<cmd>bp<CR>", "[P]revious Buffer")
map("<leader>P", "<cmd>b#<CR>", "[P]revious Buffer Opened")

-- disables arrow keys in normal mode, form better habits
map("<left>", '<cmd>echo "Use h to move!!"<CR>', "<left> Arrow Key Warning")
map("<right>", '<cmd>echo "Use l to move!!"<CR>', "<right> Arrow Key Warning")
map("<up>", '<cmd>echo "Use k to move!!"<CR>', "<up> Arrow Key Warning")
map("<down>", '<cmd>echo "Use j to move!!"<CR>', "<down> Arrow Key Warning")

local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'Keymap: ' .. desc })
end

-- leader key to space
vim.g.mapleader = ' '

-- simple write file, slightly faster
map('<leader>w', vim.cmd.write, '[W]rite')

-- project view, opens upfile selection
map('<leader>pv', vim.cmd.NvimTreeToggle, '[P]roject [V]iew')

-- half page jumping keeps cursor in the middle, less dissorienting
map('<C-d>', '<C-d>zz', 'Page [D]own')
map('<C-u>', '<C-u>zz', 'Page [U]p')

-- similar to above, searching keeps terms in the middle of the screen
map('n', 'nzzzv', '[N]ext')
map('N', 'Nzzzv', 'Previous')

-- yank into the system clipboard
map('<leader>y', [["+y]], '[Y]ank To System Clipboard', { 'n', 'v' })
map('<leader>Y', [["+Y]], '[Y]ank To System Clipboard')

-- don't use it, normally enters command mode
map('Q', '<nop>', 'Noop')

-- set up our leader keys to split horizontally and vertically, similar to tmux
map('<leader>-', '<C-w>s', '[H]orizontal Split')
map('<leader>_', '<C-w>v', '[V]ertical Split')

-- easy navigation of quick suggestions
map('<C-k>', '<cmd>cnext<CR>zz', 'Quickfix Next')
map('<C-j>', '<cmd>cprev<CR>zz', 'Quickfix Previous')
map('<leader>k', '<cmd>lnext<CR>zz', 'Location List Next')
map('<leader>j', '<cmd>lprev<CR>zz', 'Location List Previous')

-- binds re-source as leader-so
map('<leader>so', vim.cmd.source, '[S]ource [O]ptions')

-- effectively a rename, changes the word you were on with
map('<leader>sc', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], '[S]ubstitute [c]urrent word')

-- makes the current file executable
map('<leader>x', '<cmd>!chmod +x %<CR>', 'Make File E[x]ecutable')

-- toggles trouble buffer at the bottom of the screen
map('<leader>tt', vim.cmd.TroubleToggle, '[T]rouble [T]oggle Drawer')

-- toggles spell check on/off
map('<leader>ts', function() vim.opt.spell = not (vim.opt.spell:get()) end, 'Toggle [T]oggle [S]pell')

-- allows you to select a bunch of text and move it around uing J and K
map('J', ":m '>+1<CR>gv=gv", 'Move Selection Down', 'v')
map('K', ":m '<-2<CR>gv=gv", 'Move Selection Up', 'v')

-- allows for pasting overtop off things from whatever is in your register,
-- while maintaining the contents on that register
map('<leader>p', [['_dP]], 'Paste Over Selection', 'x')

-- redetects a file type for the open file, little bit of a hack but new files often go undetected,
-- unsure why
-- map('<leader>d', ":filetype detect<CR>", '[D]etect filetype')

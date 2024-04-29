local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'Telescope: ' .. desc })
end

local telescope = require('telescope.builtin')
map('<leader>ff', telescope.find_files, '[F]ind [f]iles in the project')
map('<leader>fo', telescope.oldfiles, '[F]ind in [o]ld files')
map('<leader>fg', telescope.live_grep, '[F]ind by [g]rep')
map('<leader>fp', telescope.grep_string, '[F]ind in [p]roject')
map('<leader>fb', telescope.buffers, '[F]ind by [b]uffers')
map('<leader>fh', telescope.help_tags, '[F]ind by [h]elp')
map('<leader>fs', telescope.lsp_document_symbols, '[F]ind by [s]ymbol')
map('<leader>fk', telescope.keymaps, '[F]ind in [k]eymaps')
map('<leader>fa', telescope.commands, '[F]ind command [a]action')
map('<leader>sp', telescope.spell_suggest, '[S]pell [c]heck')

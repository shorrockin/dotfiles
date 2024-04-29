local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'Harpoon: ' .. desc })
end

map('<leader>a', mark.add_file, '[A]dd file to Harpoon')
map('<C-e>', ui.toggle_quick_menu, '[E]dit Harpoon files')

map('<C-f>', function() ui.nav_file(1) end, 'Navigate to first file')
map('<C-g>', function() ui.nav_file(2) end, 'Navigate to second file')
map('<C-c>', function() ui.nav_file(3) end, 'Navigate to third file')
map('<C-r>', function() ui.nav_file(4) end, 'Navigate to fourth file')

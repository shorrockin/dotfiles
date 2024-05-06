return {
    -- Tree view: https://github.com/nvim-tree/nvim-tree.lua
    'nvim-tree/nvim-tree.lua',
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        -- empty setup using defaults
        require("nvim-tree").setup({
            view = {
                side = "left",
                width = {max = "30%"}, -- indicates dynamically sized
            },
            filters = { custom = { "^.git$" } },
            update_focused_file = {
                enable = true,
                update_cwd = true,
                ignore_list = {},
            }
        })

        -- keymaps
        vim.keymap.set('n', '<leader>tp', vim.cmd.NvimTreeToggle, { desc = 'NvimTree: [T]oggle [P]roject' })
        vim.keymap.set('n', '<leader>tf', vim.cmd.NvimTreeFindFile, { desc = 'NvimTree: [T]oggle [F]ile' })
        vim.keymap.set('n', '<leader>ct', vim.cmd.NvimTreeCollapse, { desc = 'NvimTree: [C]ollapse [T]ree' })
    end
}

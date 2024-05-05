return {
    -- Treesitter: language parsing, highlighting, etc
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        -- empty setup using defaults
        require("nvim-tree").setup({
            filters = { custom = { "^.git$" } },
            update_focused_file = {
                enable = true,
                update_cwd = true,
                ignore_list = {},
            }
        })
    end
}

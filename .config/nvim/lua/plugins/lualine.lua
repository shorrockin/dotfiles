return {
    -- LuaLine: https://github.com/nvim-lualine/lualine.nvim - status line
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
            options = {
                theme = "catppuccin"
                -- ... the rest of your lualine config
            }
        }
    end
}

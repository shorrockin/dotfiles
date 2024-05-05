return {
    -- Color Scheme: https://github.com/catppuccin/nvim
    'catppuccin/nvim',
    priority = 1000, -- load this before all the other start plugins
    name = 'catppuccin',
    config = function()
        vim.cmd('colorscheme catppuccin')
    end
}

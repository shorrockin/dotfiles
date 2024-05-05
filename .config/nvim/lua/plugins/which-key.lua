return {
    -- Whichkey: https://github.com/folke/which-key.nvim - autocomplete key suggestions
    "folke/which-key.nvim",
    event = 'VimEnter', -- load after vim has started, speeds up load times
    config = function()
        require("which-key").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end
}

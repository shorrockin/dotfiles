return {
    "akinsho/bufferline.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "Explorer",
                    highlight = "PanelHeading",
                    padding = 1,
                },
            }
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
    end
}

return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
        require('neoclip').setup()
        require('telescope').load_extension('neoclip')
        vim.keymap.set("n", "<leader>fc", ':Telescope neoclip<CR>', { desc = 'Telescope: [F]ind [c]lipboard' })
    end
}

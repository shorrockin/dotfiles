return {
	-- Bufferline: https://github.com/akinsho/bufferline.nvim
	-- A snazzy bufferline for neovim, effectively looks like tabs at the top of
	-- the neovim window, integrates with the lsp, git, etc.
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
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
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
	end,
}

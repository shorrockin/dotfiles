return {
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render-markdown").setup({})
	end,
}

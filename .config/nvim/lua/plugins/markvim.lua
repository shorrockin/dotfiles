return {
	-- https://github.com/oxy2dev/markview.nvim
	-- experimental markdown editor
	"OXY2DEV/markview.nvim",
	ft = { "markdown" },
	-- on the fence, not sure i like obscring the markdown this much
	enabled = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({})
	end,
}

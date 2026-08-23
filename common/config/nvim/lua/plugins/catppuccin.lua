return {
	-- Color Scheme: https://github.com/catppuccin/nvim
	"catppuccin/nvim",
	priority = 1000, -- load this before all the other start plugins
	name = "catppuccin",
	opts = {
		transparent_background = true,
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			notify = false,
			snacks = {
				enabled = false,
				indent_scope_color = "",
			},
			mini = {
				enabled = true,
				indentscope_color = "",
			},
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}

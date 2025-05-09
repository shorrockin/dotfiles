return {
	-- Color Scheme: https://github.com/catppuccin/nvim
	"catppuccin/nvim",
	priority = 1000, -- load this before all the other start plugins
	name = "catppuccin",
	integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
		snacks = {
			enabled = false,
			indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
		},
        mini = {
            enabled = true,
            indentscope_color = "",
        },
	},
	config = function()
		vim.cmd("colorscheme catppuccin")
	end,
}

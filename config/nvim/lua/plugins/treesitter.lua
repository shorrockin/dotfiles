return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"ruby",
					"lua",
					"vim",
					"query",
					"rust",
					"javascript",
					"html",
					"luadoc",
					"markdown",
					"markdown_inline",
					"regex",
				},
			})
			-- Highlighting is enabled by default in new nvim-treesitter
			-- Incremental selection via nvim-treesitter-textobjects or manual keymaps
			vim.keymap.set("n", "<c-space>", function()
				require("nvim-treesitter.incremental_selection").init_selection()
			end, { desc = "Init treesitter selection" })
			vim.keymap.set("v", "<c-space>", function()
				require("nvim-treesitter.incremental_selection").node_incremental()
			end, { desc = "Increment treesitter selection" })
			vim.keymap.set("v", "<c-backspace>", function()
				require("nvim-treesitter.incremental_selection").node_decremental()
			end, { desc = "Decrement treesitter selection" })
		end,
	},
	{
		-- Treesitter: context of current method
		-- https://github.com/nvim-treesitter/nvim-treesitter-context
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			enable = true,
			max_lines = 2,
			line_numbers = true,
			multiline_threshold = 2,
		},
	},
}

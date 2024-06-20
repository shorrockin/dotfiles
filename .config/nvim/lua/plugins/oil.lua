return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		oil.setup({
			view_options = {
				show_hidden = true,
			},

			float = {
				padding = 10,
			},

			keymaps = {
				["<ESC>"] = "actions.close",
			},
		})

		-- "Toggle Project" doesn't _really_ make sense for oil, but old habbits
		-- die hard, and this is just what we're used to
		vim.keymap.set("n", "<leader>tp", oil.open_float, { desc = "Oil: [T]oggle [P]roject" })
	end,
}

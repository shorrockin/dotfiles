return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		oil.setup({
			view_options = {
				show_hidden = true,
			},

			keymaps = {
				["<ESC>"] = "actions.close",
				["<C-v>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Oil: Open the entry in a [v]ertical split",
				},
				["<C-r>"] = "actions.refresh",
				-- disable: conflicts with our split navigation
				["<C-h>"] = false,
				["<C-l>"] = false,
				-- disable: conflicts with our tmux session navigator
				["<C-s>"] = false,
			},
		})

		vim.keymap.set("n", "-", vim.cmd.Oil, { desc = "Oil: Open parent directory" })
	end,
}

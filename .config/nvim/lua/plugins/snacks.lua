return {
	-- collection of small useful improvements
	-- https://github.com/folke/snacks.nvim
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		dashboard = { enabled = true },
	},
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Snack: Toggle Scratch Buffer",
		},
		-- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		{
			"<leader>fn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Snack: [F]ind [N]notification",
		},
		-- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		-- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Snack: [G]it [B]rowse",
		},
		-- { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
		-- { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
		-- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		-- { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Snack: [U]ndo / Dismiss All [N]otifications",
		},
		-- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
		-- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
		-- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		-- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
	},
}

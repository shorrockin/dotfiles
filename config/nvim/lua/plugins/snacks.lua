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
		-- scroll = { enabled = true }, -- makes ui feel a bit slow
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		picker = { layout = "vertical" },
		dashboard = {
			sections = {
				{ section = "header" },
				-- {
				-- 	pane = 2,
				-- 	section = "terminal",
				-- 	cmd = "colorscript -e square",
				-- 	height = 5,
				-- 	padding = 1,
				-- },
				{ section = "keys", gap = 1, padding = 1 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
	},
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Snacks: Toggle Scratch Buffer",
		},
		-- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		{
			"<leader>fn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Snacks: [f]ind [n]otification",
		},
		-- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		-- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		-- {
		-- 	"<leader>gu",
		-- 	function()
		-- 		Snacks.gitbrowse()
		-- 	end,
		-- 	desc = "Snacks: [G]it Open [U]rl",
		-- },
		-- { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
		-- { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
		-- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		-- { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Snacks: [u]ndo / Dismiss All [n]otifications",
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
		-- Picker Bindings: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true, follow = true })
			end,
			desc = "Snacks: [f]ind [f]iles",
		},
		{
			"<leader>fo",
			function()
				Snacks.picker.recent()
			end,
			desc = "Snacks: [f]ind [o]ld / Recent Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep({ hidden = true, follow = true })
			end,
			desc = "Snacks: [f]ind by [g]rep",
		},
		{
			"<leader>fG",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Snacks: [f]ind by [G]rep in buffers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Snacks: [f]ind [h]elp",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Snacks: [f]ind by [k]eymaps",
		},
		{
			"<leader>fa",
			function()
				Snacks.picker.commands()
			end,
			desc = "Snacks: [f]ind [a]ction / Command",
		},
		{
			"<leader>fm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Snacks: [f]ind [m]arks",
		},
		{
			"<leader>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Snacks: Find [b]uffer",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Snacks LSP: [f]ind [s]ymbol",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Snacks LSP: [g]oto [d]efinition",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "Snacks LSP: [g]oto [r]eferences",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Snacks LSP: [g]oto [I]mplementation",
		},
		{
			"<leader>D",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Snacks LSP: Type [D]efinition",
		},
	},
}

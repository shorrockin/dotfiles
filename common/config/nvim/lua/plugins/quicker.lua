return {
	-- Quicker: Enhanced quickfix window: https://github.com/stevearc/quicker.nvim
	"stevearc/quicker.nvim",
	event = "FileType qf",
	opts = {
		-- Enable syntax highlighting for grep results
		highlight = {
			treesitter = true,
			lsp = true,
		},
		-- Show context lines above and below quickfix items
		-- Set to 0 to disable
		-- context = 3,

		-- Local buffer options for quickfix window
		opts = {
			number = true,
			relativenumber = false,
			wrap = false,
		},

		-- Enable editing functionality
		edit = {
			enabled = true,
			autosave = "always", -- Auto-save changes to files
		},

		-- Trim leading whitespace from results
		trim_leading_whitespace = true,

		-- Borders for visual separation
		borders = {
			vert = "┃",
			-- Uncomment to customize other borders
			-- strong_header = "━",
			-- soft_header = "╍",
		},

		-- Custom icons for error types
		-- type_icons = {
		-- 	E = "",
		-- 	W = "",
		-- 	I = "",
		-- 	N = "",
		-- 	H = "",
		-- },
	},
	config = function(_, opts)
		require("quicker").setup(opts)

		-- Keybindings
		vim.keymap.set("n", "<leader>qq", function()
			require("quicker").toggle()
		end, { desc = "Quicker: Toggle [q]uickfix" })

		vim.keymap.set("n", "<leader>ql", function()
			require("quicker").toggle({ loclist = true })
		end, { desc = "Quicker: Toggle [l]oclist" })

		-- Optional: Expand/collapse context in quickfix window
		vim.keymap.set("n", "<leader>qe", function()
			require("quicker").expand()
		end, { desc = "Quicker: [e]xpand context" })

		vim.keymap.set("n", "<leader>qc", function()
			require("quicker").collapse()
		end, { desc = "Quicker: [c]ollapse context" })
	end,
}

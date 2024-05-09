return {
	"almo7aya/openingh.nvim",
	config = function()
		vim.keymap.set(
			{ "n", "v" },
			"<leader>gu",
			":OpenInGHFileLines<CR>",
			{ desc = "[G]ithub [U]rl", silent = true, noremap = true }
		)
		-- TODO this doesn't seem to work, need to dig in more
		vim.keymap.set(
			{ "n", "v" },
			"<leader>gcu",
			":OpenInGHFileLines+ <CR>",
			{ desc = "[G]ithub [C]opy [U]rl", silent = true, noremap = true }
		)
	end,
}

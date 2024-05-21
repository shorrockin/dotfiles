return {
	-- https://github.com/Almo7aya/openingh.nvim
	-- Open a file in github based on the current selection seems to have some problems
	-- if you don't open from project root.
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

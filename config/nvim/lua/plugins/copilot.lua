return {
	-- Google copilot: https://github.com/github/copilot.vim
	"github/copilot.vim",
	-- Lua version of above: https://github.com/zbirenbaum/copilot.lua
	-- "zbirenbaum/copilot.lua",
	event = "VeryLazy",
	enabled = true,
	setup = function()
		-- require("copilot").setup()
		vim.keymap.set("i", "<C-i>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			desc = "Copilot: Accept suggestion",
		})
		vim.g.copilot_no_tab_map = true
	end,
}

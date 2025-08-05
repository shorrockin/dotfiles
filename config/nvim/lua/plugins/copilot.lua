return {
	-- Google copilot: https://github.com/github/copilot.vim
	"github/copilot.vim",
	-- Lua version of above: https://github.com/zbirenbaum/copilot.lua
	-- "zbirenbaum/copilot.lua",
	event = "VeryLazy",
	enabled = true,
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			desc = "Copilot: Accept suggestion",
		})
	end,
}

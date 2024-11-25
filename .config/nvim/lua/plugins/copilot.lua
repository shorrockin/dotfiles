return {
	-- Google copilot: https://github.com/github/copilot.vim
	"github/copilot.vim",
	enabled = true,
	setup = function()
		vim.keymap.set("i", "<C-i>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			desc = "Copilot: Accept suggestion",
		})
		vim.g.copilot_no_tab_map = true
	end,
}

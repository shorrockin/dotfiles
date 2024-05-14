return {
	-- Indentation Guides: https://github.com/lukas-reineke/indent-blankline.nvim
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	enabled = false, -- currently too much visual noise, may re-add?
	opts = {},
	config = function()
		require("ibl").setup({
			scope = {
				show_start = false,
				show_end = false,
			},
			-- show_current_context = true,
			-- show_first_indent_level = false,
			-- filetype_exclude = {
			--  'packer',
			--  'markdown',
			--  'help',
			--  'TelescopePrompt',
			--  'Trouble',
			--  '',
			--},
			--buftype_exclude = { 'terminal', 'nofile' },
			--show_trailing_blankline_indent = false,
		})
	end,
}

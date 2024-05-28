return {
	-- Leap: https://github.com/ggandor/leap.nvim
	-- quickly navigate to a spot in the current file using s/S then two letters
	-- plus an identifier
	"https://github.com/ggandor/leap.nvim",
	enabled = false, -- disabled in favor of flash
	config = function()
		require("leap").create_default_mappings()
		-- set the backdrop color to the same as the comment color when searching, which should cause the search targets to jump out a little more
		vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
	end,
}

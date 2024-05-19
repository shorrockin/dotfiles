return {
	-- Leap: require('leap').create_default_mappings()
	-- quickly navigate to a spot in the current file using s/S then two letters
	-- plus an identifier
	"https://github.com/ggandor/leap.nvim",
	config = function()
		require("leap").create_default_mappings()
	end,
}

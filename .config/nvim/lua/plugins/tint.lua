return {
	-- Tint: https://github.com/levouh/tint.nvim
	-- fades the active window in/out so i can more easily identify which window
	-- is currently active.
	"levouh/tint.nvim",
	config = function()
		require("tint").setup()
	end,
}

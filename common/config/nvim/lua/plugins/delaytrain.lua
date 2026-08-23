return {
	-- https://github.com/ja-ford/delaytrain.nvim
	-- Delaytrain: imposes key pauses on bad motion usages to train you to
	-- develop better vim habbits.
	"ja-ford/delaytrain.nvim",
	enabled = false,
	config = function()
		require("delaytrain").setup({
			grace_period = 3,
		})
	end,
}

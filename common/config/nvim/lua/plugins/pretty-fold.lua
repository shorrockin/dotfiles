return {
	-- https://github.com/anuvyklack/pretty-fold.nvim
	-- makes folds less ugly, maybe we don't need this, do we use folds that much?
	"anuvyklack/pretty-fold.nvim",
	enabled = false,
	config = function()
		require("pretty-fold").setup()
	end,
}

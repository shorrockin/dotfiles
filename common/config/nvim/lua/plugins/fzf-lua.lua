return {
	-- Fuzzy finder for files: https://github.com/ibhagwan/fzf-lua
	"ibhagwan/fzf-lua",
	config = function()
		require("fzf-lua").setup({
			winopts = { preview = { default = "bat" } },
		})
	end,
}

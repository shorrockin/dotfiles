return {
	-- Fuzzy finder for files: https://github.com/ibhagwan/fzf-lua
	"ibhagwan/fzf-lua",
	opts = {
		files = { previewer = false },
		-- This is required to support older version of fzf
		fzf_opts = { ["--border"] = false },
		-- These settings reduce lag from slow git operations
		global_git_icons = false,
		git = {
			files = {
				previewer = false,
			},
		},
	},
	config = function(_, opts)
		require("fzf-lua").setup(opts)
	end,
}

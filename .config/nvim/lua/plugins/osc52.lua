return {
	-- https://github.com/ojroques/nvim-osc52
	-- copy to clipboard locally when connected to a remote box, will not
	-- be needed in nvim 10
	"ojroques/nvim-osc52",
	config = function()
		require("osc52").setup({
			max_length = 0, -- Maximum length of selection (0 for no limit)
			silent = true, -- Disable message on successful copy
			tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
		})

		vim.api.nvim_create_autocmd("TextYankPost", {
			callback = function()
				if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
					require("osc52").copy_register("+")
				end
			end,
		})
	end,
}

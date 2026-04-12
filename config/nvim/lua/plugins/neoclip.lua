return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		require("neoclip").setup({
			keys = {
				telescope = {
					i = { select = "<nop>", paste = "<cr>", paste_behind = "<c-k>" },
					n = { select = "<nop>", paste = "<cr>", paste_behind = "P" },
				},
			},
		})
		require("telescope").load_extension("neoclip")
		vim.keymap.set("n", "<leader>fc", ":Telescope neoclip<CR>", { desc = "Telescope: [F]ind [c]lipboard" })
	end,
}

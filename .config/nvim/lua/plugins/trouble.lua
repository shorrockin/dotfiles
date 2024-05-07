return {
	-- Trouble: show error messages in gutter https://github.com/folke/trouble.nvim
	"folke/trouble.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("trouble").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		})

		-- keymaps
		vim.keymap.set("n", "<leader>tt", vim.cmd.TroubleToggle, { desc = "Trouble: [T]oggle [T]rouble Drawer" })
	end,
}

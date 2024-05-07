return {
	{
		-- Crates: https://github.com/Saecki/crates.nvim - manages rust crate dependencies
		"saecki/crates.nvim",
		tag = "v0.3.0",
		dependencies = { "nvim-lua/plenary.nvim", "jose-elias-alvarez/null-ls.nvim" },
		config = function()
			require("crates").setup()
		end,
	},
}

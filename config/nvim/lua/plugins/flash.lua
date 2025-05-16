return {
	-- https://github.com/folke/flash.nvim
	-- better fash searching across a file, integrations with treesitter, assists normal f/t/f/T
	-- bindings. alternative to leap, sneak, etc
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Search",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter (select region)",
		},
	},
}

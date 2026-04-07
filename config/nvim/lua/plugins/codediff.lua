return {
	-- https://github.com/esmuellert/codediff.nvim
	-- codediff: VSCode-style side-by-side diff with two-tier highlighting
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{ "<leader>cd", "<cmd>CodeDiff<CR>", desc = "CodeDiff: [C]ode [D]iff" },
		{ "]e", function() require("codediff").next_hunk() end, desc = "CodeDiff: Next hunk" },
		{ "[e", function() require("codediff").prev_hunk() end, desc = "CodeDiff: Previous hunk" },
	},
	opts = {},
}

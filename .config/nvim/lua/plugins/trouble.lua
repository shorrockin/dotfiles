return {
	-- Trouble: show error messages in gutter https://github.com/folke/trouble.nvim
	"folke/trouble.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local trouble = require("trouble")
		trouble.setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
		})

		vim.keymap.set(
			"n",
			"<leader>tt",
			"<cmd>Trouble diagnostics toggle<cr>",
			{ desc = "Trouble: [T]oggle [T]rouble Drawer" }
		)
		--[[
		vim.keymap.set("n", "<leader>tq", function()
			trouble.toggle("quickfix")
		end, { desc = "Trouble: [T]rouble Toggle [Q]uickfix" })

		vim.keymap.set("n", "<leader>xl", function()
			trouble.toggle("loclist")
		end, { desc = "Trouble: Trouble Toggle [L]oclist" })
]]
		vim.keymap.set("n", "<leader>xn", function()
			trouble.next({ skip_groups = true, jump = true })
		end, { desc = "Trouble: Trouble [N]ext" })

		vim.keymap.set("n", "<leader>xp", function()
			trouble.previous({ skip_groups = true, jump = true })
		end, { desc = "Trouble: Trouble [P]revious" })
	end,
}

return {
	-- Harpoon: https://github.com/ThePrimeagen/harpoon
	-- allows you to store a list of frequently accessed files then quick
	-- navigate between them.
	"theprimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		require("harpoon").setup({
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		})

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { desc = "Harpoon: " .. desc })
		end

		map("<leader>ha", mark.add_file, "[A]dd file")
		map("<leader>he", ui.toggle_quick_menu, "[E]dit file(s)")

		map("<C-a>", function()
			ui.nav_file(1)
		end, "Navigate to first file")
		map("<C-o>", function()
			ui.nav_file(2)
		end, "Navigate to second file")
		map("<C-e>", function()
			ui.nav_file(3)
		end, "Navigate to third file")
		-- hmmm - C-u collides with page up, maybe find some different harpoon bindings?
		-- map("<C-u>", function()
		-- 	ui.nav_file(4)
		-- end, "Navigate to fourth file")
		-- map("<C-i>", function()
		-- 	ui.nav_file(5)
		-- end, "Navigate to firfth file")
	end,
}

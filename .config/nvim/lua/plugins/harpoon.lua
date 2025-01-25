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
			vim.keymap.set(mode, keys, func, { desc = "Harpoon: " .. desc, noremap = true, silent = true })
		end

		map("<leader>ha", mark.add_file, "[A]dd file")
		map("<leader>he", ui.toggle_quick_menu, "[E]dit file(s)")

		local tab = function(index)
			return function()
				ui.nav_file(index)
			end
		end

		map("<C-a>", tab(1), "Navigate to first file")
		map("<C-o>", tab(2), "Navigate to second file")
		map("<C-e>", tab(3), "Navigate to third file")
		-- map("<M-a>", tab(4), "Navigate to fourth file")
		-- map("<M-o>", tab(5), "Navigate to fifth file")
		-- map("<M-e>", tab(6), "Navigate to sixth file")
	end,
}

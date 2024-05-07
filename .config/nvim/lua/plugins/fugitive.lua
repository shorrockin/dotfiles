return {
	-- Fugitive: git client, bind to gs (git-status): https://github.com/tpope/vim-fugitive
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive: [G]it [s]tatus" })
		vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { desc = "Fugitive: [G]it [d]iff" })
		vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Fugitive: [G]it [c]ommit" })
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Fugitive: [G]it [p]ush" })

		function ConfirmRestore()
			local choice = vim.fn.confirm("Restore Git File?", "&Yes\n&No", 2)
			if choice == 1 then
				vim.cmd("Gread")
			end
		end
		vim.keymap.set("n", "<leader>gr", ":lua ConfirmRestore()<CR>", { desc = "Fugitive: [G]it [R]estore File" })
	end,
}

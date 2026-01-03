return {
	-- Vim Signature: https://github.com/kshenoy/vim-signature
	-- marks in the gutter
	"kshenoy/vim-signature",
	config = function()
		vim.keymap.set("n", "<leader>tm", vim.cmd.SignatureToggle, { desc = "Signature: [t]oggle All [m]arks" })
		vim.keymap.set("n", "<leader>dam", function()
			vim.api.nvim_command("delmarks!")
			vim.api.nvim_command("wshada!")
		end, { desc = "Signature: [d]elete [a]ll [m]arks" })
	end,
}

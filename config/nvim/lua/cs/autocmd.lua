vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Copy to system clipboard when yanking into a register",
	group = vim.api.nvim_create_augroup("yank-to-clipboard", { clear = true }),
	callback = function(ev)
		vim.api.nvim_call_function("system", { "pbcopy", vim.api.nvim_call_function("getreg", { ev.regname }) })
	end,
})

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

vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable line wrapping for Markdown files",
	group = vim.api.nvim_create_augroup("markdown-wrap", { clear = true }),
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true -- break lines at word boundaries
	end,
})

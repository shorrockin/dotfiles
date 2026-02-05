if vim.fn.isdirectory(vim.fn.expand("~/stripe")) == 1
	or vim.fn.filereadable(vim.fn.expand("~/.stripeproxy")) == 1 then
	return {}
end

return {
	name = "gopls",
	config = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = vim.fs.dirname(vim.fs.find({ "go.work", "go.mod", ".git" }, { upward = true })[1]),
		settings = {
			gopls = {
				completeUnimported = true,
				-- usePlaceholders = true,
				analyses = {
					-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
					unusedparams = true,
					unusedvariable = true,
					unreachable = true,
				},
			},
		},
	},
}

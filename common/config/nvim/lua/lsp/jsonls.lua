return {
	name = "jsonls",
	config = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_dir = vim.fs.dirname(vim.fs.find({ ".git", "package.json" }, { upward = true })[1]),
		settings = {
			json = {
				validate = { enable = true },
			},
		},
	},
}

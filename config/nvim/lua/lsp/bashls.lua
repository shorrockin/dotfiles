return {
	name = "bashls",
	config = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
	},
}

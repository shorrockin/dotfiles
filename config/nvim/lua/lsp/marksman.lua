return {
	name = "marksman",
	config = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown", "markdown.mdx" },
		root_dir = vim.fs.dirname(vim.fs.find({ ".git", ".marksman.toml" }, { upward = true })[1]),
	},
}

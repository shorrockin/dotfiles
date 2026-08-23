return {
	name = "yamlls",
	config = {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml", "yaml.docker-compose" },
		root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	},
}

return {
	name = "rust_analyzer",
	config = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_dir = vim.fs.dirname(vim.fs.find({ "Cargo.toml", ".git" }, { upward = true })[1]),
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}

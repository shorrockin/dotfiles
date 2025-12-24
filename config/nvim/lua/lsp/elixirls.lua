return {
	name = "elixirls",
	config = {
		cmd = { "elixir-ls" },
		filetypes = { "elixir", "eelixir", "heex", "surface" },
		root_dir = vim.fs.dirname(vim.fs.find({ "mix.exs", ".git" }, { upward = true })[1]),
	},
}

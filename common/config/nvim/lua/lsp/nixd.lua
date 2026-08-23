return {
	name = "nixd",
	config = {
		cmd = { "nixd" },
		filetypes = { "nix" },
		root_dir = vim.fs.dirname(vim.fs.find({ "flake.nix", ".git" }, { upward = true })[1]),
		settings = {
			nixd = {
				formatting = {
					command = { "nixfmt" }, -- uses nixfmt-classic from NixOS
				},
			},
		},
	},
}

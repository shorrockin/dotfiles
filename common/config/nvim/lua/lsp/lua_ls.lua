return {
	name = "lua_ls",
	config = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_dir = vim.fs.dirname(vim.fs.find({ ".git", ".luarc.json", ".luarc.jsonc" }, { upward = true })[1]),
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				completion = {
					callSnippet = "Replace",
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
					},
				},
				diagnostics = {
					globals = { "vim", "Snacks" },
				},
			},
		},
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		-- Treesitter: context of current method
		-- https://github.com/nvim-treesitter/nvim-treesitter-context
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or 'all' (the five listed parsers should always be installed)
				ensure_installed = {
					"ruby",
					"lua",
					"vim",
					"query",
					"rust",
					"javascript",
					"html",
					"luadoc",
					"markdown",
					"vim",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = '/some/path/to/store/parsers', -- Remember to run vim.opt.runtimepath:append('/some/path/to/store/parsers')!

				-- incremental selection allows for syntaticatly expanding selection regions,
				-- bound to ctrl-space by default
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},

				highlight = {
					enable = true,
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages.
					additional_vim_regex_highlighting = { "ruby" },
					indent = { enable = true, disable = { "ruby" } },
				},
			})

			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
				-- min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 2, -- Maximum number of lines to show for a single context
				-- trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				-- mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- separator = nil,
				-- zindex = 20, -- The Z-index of the context window
				-- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
}

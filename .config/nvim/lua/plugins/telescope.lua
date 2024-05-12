return {
	-- Telescope: fuzzy finder: https://github.com/nvim-telescope/telescope.nvim
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	tag = "0.1.4",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },

		-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = vim.fn.executable("make") == 1,
		},
		-- allows neovim core to use telescope picker
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{
			"nvim-tree/nvim-web-devicons",
			enabled = vim.g.have_nerd_font,
		},
	},
	config = function()
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { desc = "Telescope: " .. desc })
		end

		local trouble = require("trouble.providers.telescope")
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "^.git/", "^node_modules/", "^vendor/" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				grep_string = {
					additional_args = { "--hidden" },
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
				buffers = {
					sort_lastused = true,
					ignore_current_buffer = true,
				},
			},
			mappings = {
				i = { ["<C-t>"] = trouble.open_with_trouble },
				n = { ["<C-t>"] = trouble.open_with_trouble },
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local telescope = require("telescope.builtin")
		-- map('<leader>ff', telescope.find_files, '[F]ind [f]iles in the project')
		map("<leader>ff", require("fzf-lua").files, "[F]ind [F]iles")
		map("<leader>fo", telescope.oldfiles, "[F]ind in [o]ld files")
		map("<leader>fg", telescope.live_grep, "[F]ind by [g]rep")
		map("<leader>fp", telescope.grep_string, "[F]ind string in [p]roject")
		map("<leader>fb", telescope.buffers, "[F]ind by [b]uffers")
		map("<leader>b", telescope.buffers, "Find by [b]uffers")
		map("<leader>fh", telescope.help_tags, "[F]ind by [h]elp")
		map("<leader>fs", telescope.lsp_document_symbols, "[F]ind by [s]ymbol")
		map("<leader>fk", telescope.keymaps, "[F]ind in [k]eymaps")
		map("<leader>fa", telescope.commands, "[F]ind command [a]action")
		map("<leader>fm", telescope.marks, "[F]ind by [m]arks")
		map("<leader>fj", telescope.jumplist, "[F]ind by [j]umplist")
		map("<leader>sp", telescope.spell_suggest, "[S]pell [c]heck")
		map("<leader>fd", telescope.diagnostics, "[F]ind [d]iagnostics")

		-- fuzzy search current buffer using telescope with customized ui
		map("<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, "[/] Fuzzily search in current buffer")

		-- shortcut for searching your Neovim configuration files, handy for quick changes
		-- or looking up to see how things are configured from a separate project
		-- TODO: this doesn't seem to work, need to investigate
		map("<leader>fn", function()
			telescope.find_files({ cwd = vim.fn.stdpath("config") })
		end, "[F]ind [N]eovim files")

		-- maps <C-d> to close the selected buffer when you are using telescope to navigate
		-- them.
	end,
}

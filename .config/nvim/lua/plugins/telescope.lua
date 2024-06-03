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
		local builtin = require("telescope.builtin")
		local action_state = require("telescope.actions.state")

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
				oldfiles = {
					theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				marks = {
					theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				find_files = {
					hidden = true,
					follow = true,
					sort_lastused = true,
					sort_mru = true,
					theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				grep_string = {
					additional_args = { "--hidden" },
					sort_lastused = true,
					sort_mru = true,
					theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				live_grep = {
					additional_args = { "--hidden" },
					theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				buffers = {
					sort_lastused = true,
					sort_mru = true,
					ignore_current_buffer = true,
					theme = "dropdown",
					layout_config = { width = 0.8 },
					-- previewer = false,
				},
			},
			mappings = {
				i = {
					["<C-t>"] = trouble.open_with_trouble,
				},
				n = {
					["<C-t>"] = trouble.open_with_trouble,
				},
			},
		})

		-- enable telescope fzf native, if installed, other extensions are loaded normally
		pcall(require("telescope").load_extension, "fzf")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("notify")

		-- map('<leader>ff', telescope.find_files, '[F]ind [f]iles in the project')
		map("<leader>ff", require("fzf-lua").files, "[F]ind [F]iles")
		map("<leader>fo", builtin.oldfiles, "[F]ind in [o]ld files")
		map("<leader>fg", builtin.live_grep, "[F]ind by [g]rep")
		map("<leader>fp", builtin.grep_string, "[F]ind string in [p]roject")
		map("<leader>fb", builtin.buffers, "[F]ind by [b]uffers")
		map("<leader>fh", builtin.help_tags, "[F]ind by [h]elp")
		map("<leader>fs", builtin.lsp_document_symbols, "[F]ind by [s]ymbol")
		map("<leader>fk", builtin.keymaps, "[F]ind in [k]eymaps")
		map("<leader>fa", builtin.commands, "[F]ind command [a]action")
		map("<leader>fm", builtin.marks, "[F]ind by [m]arks")
		map("<leader>fj", builtin.jumplist, "[F]ind by [j]umplist")
		map("<leader>sp", builtin.spell_suggest, "[S]pell [c]heck")
		map("<leader>fd", builtin.diagnostics, "[F]ind [d]iagnostics")
		map("<leader>fn", function()
			require("telescope").extensions.notify.notify()
		end, "[F]ind [n]otifications")

		-- fuzzy search current buffer using telescope with customized ui
		map("<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, "[/] Fuzzily search in current buffer")

		map("<leader>b", function()
			-- TODO figure out how to bind this, without page down taking over
			-- local delete_buffer = function(prompt_bufnr)
			-- 	local current_picker = action_state.get_current_picker(prompt_bufnr)
			-- 	current_picker:delete_selection(function(selection)
			-- 		vim.api.nvim_buf_delete(selection.bufnr, { force = true })
			-- 	end)
			-- end

			builtin.buffers({
				-- attach_mappings = function(_, mapping)
				-- 	mapping("i", "<C-o>", delete_buffer)
				-- 	mapping("n", "<C-o>", delete_buffer)
				-- 	return true
				-- end,
			})
		end, "Find by [b]uffers")

		-- shortcut for searching your Neovim configuration files, handy for quick changes
		-- or looking up to see how things are configured from a separate project
		map("<leader>fv", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, "[F]ind Neo[v]im files")
	end,
}

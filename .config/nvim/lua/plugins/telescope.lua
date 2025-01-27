return {
	-- Telescope: fuzzy finder: https://github.com/nvim-telescope/telescope.nvim
	"nvim-telescope/telescope.nvim",
	-- enabled = false, -- in favor of snacks for now
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

		vim.api.nvim_set_hl(0, "MyCustomGrey", { fg = "#5C6370", bg = "NONE" })

		-- local trouble = require("trouble.providers.telescope")
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "^.git/", "^node_modules/", "^vendor/" },
				path_display = { "smart" },
				-- path_display = function(_, path)
				-- 	local utils = require("telescope.utils")
				-- 	local tail = utils.path_tail(path)
				-- 	local display = string.format("%s (%s)", tail, path)
				--
				-- 	-- Apply custom grey highlight to the tail
				-- 	return display, { { { 1, #tail }, "MyCustomGrey" } }
				-- end,
				-- path_display = function(opts, path)
				-- 	local tail = require("telescope.utils").path_tail(path)
				-- 	return string.format("%s (%s)", tail, path), { { { 1, #tail }, "Constant" } }
				-- end,
			},
			pickers = {
				oldfiles = {
					layout_config = { width = 0.8 },
				},
				marks = {
					layout_config = { width = 0.8 },
				},
				find_files = {
					hidden = true,
					follow = true,
					sort_lastused = true,
					sort_mru = true,
					layout_config = { width = 0.8 },
				},
				grep_string = {
					additional_args = { "--hidden" },
					sort_lastused = true,
					sort_mru = true,
					-- theme = "dropdown",
					layout_config = { width = 0.8 },
				},
				live_grep = {
					additional_args = { "--hidden" },
					layout_config = { width = 0.8 },
				},
				buffers = {
					sort_lastused = true,
					sort_mru = true,
					ignore_current_buffer = false,
					layout_config = { width = 0.8 },
				},
			},
			mappings = {
				i = {
					["<C-t>"] = require("trouble.sources.telescope").open,
				},
				n = {
					["<C-t>"] = require("trouble.sources.telescope").open,
				},
			},
		})

		-- enable telescope fzf native, if installed, other extensions are loaded normally
		pcall(require("telescope").load_extension, "fzf")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("notify")
		--
		-- -- map('<leader>ff', telescope.find_files, '[F]ind [f]iles in the project')
		-- map("<leader>ff", require("fzf-lua").files, "[F]ind [F]iles")
		-- map("<leader>fo", builtin.oldfiles, "[F]ind in [o]ld files")
		-- map("<leader>fg", builtin.live_grep, "[F]ind by [g]rep")
		-- map("<leader>fp", builtin.grep_string, "[F]ind string in [p]roject")
		-- map("<leader>fh", builtin.help_tags, "[F]ind by [h]elp")
		-- map("<leader>fs", builtin.lsp_document_symbols, "[F]ind by [s]ymbol")
		-- map("<leader>fk", builtin.keymaps, "[F]ind in [k]eymaps")
		-- map("<leader>fa", builtin.commands, "[F]ind command [a]action")
		-- map("<leader>fm", builtin.marks, "[F]ind by [m]arks")
		-- map("<leader>fj", builtin.jumplist, "[F]ind by [j]umplist")
		-- map("<leader>sp", builtin.spell_suggest, "[S]pell [c]heck")
		-- map("<leader>fd", builtin.diagnostics, "[F]ind [d]iagnostics")
		-- map("<leader>fq", builtin.quickfix, "[F]ind in [Q]uickfix")
		-- -- replaced by snack.nvim binding
		-- map("<leader>fn", function()
		-- 	require("telescope").extensions.notify.notify()
		-- end, "[F]ind [n]otifications")
		--
		-- -- fuzzy search current buffer using telescope with customized ui
		-- map("<leader>/", function()
		-- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		-- 		winblend = 10,
		-- 		previewer = false,
		-- 	}))
		-- end, "[/] Fuzzily search in current buffer")
		--
		-- local open_buffers = function()
		-- 	builtin.buffers({
		-- 		attach_mappings = function(_, am)
		-- 			local delete_buffer = function(prompt_bufnr)
		-- 				local current_picker = action_state.get_current_picker(prompt_bufnr)
		-- 				current_picker:delete_selection(function(selection)
		-- 					vim.api.nvim_buf_delete(selection.bufnr, { force = true })
		-- 				end)
		-- 			end
		--
		-- 			am("i", "<C-d>", delete_buffer)
		-- 			am("n", "<C-d>", delete_buffer)
		-- 			return true
		-- 		end,
		-- 	})
		-- end
		--
		-- map("<leader>b", open_buffers, "Find by [b]uffers")
		-- map("<leader>fb", open_buffers, "[F]ind by [b]uffers")
		--
		-- -- shortcut for searching your Neovim configuration files, handy for quick changes
		-- -- or looking up to see how things are configured from a separate project
		-- map("<leader>fv", function()
		-- 	builtin.find_files({ cwd = vim.fn.stdpath("config") })
		-- end, "[F]ind Neo[v]im files")
	end,
}

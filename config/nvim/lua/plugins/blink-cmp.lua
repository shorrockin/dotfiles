return {
	-- blink.cmp: Fast completion plugin with LSP, snippet, and path support
	-- https://github.com/saghen/blink.cmp
	"saghen/blink.cmp",
	version = "v0.*",
	event = "InsertEnter",
	dependencies = {
		-- Keep LuaSnip for existing custom snippets
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
	},
	opts = {
		keymap = {
			preset = "default",
			-- Maintain similar keybindings to nvim-cmp
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-y>"] = { "accept", "fallback" }, -- Additional accept key (nvim-cmp style)

			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			-- Snippet navigation (similar to nvim-cmp + luasnip)
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		snippets = {
			preset = "luasnip",
		},

		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = false, -- Disabled to avoid conflicts with Copilot
			},
		},

		signature = {
			enabled = true,
		},
	},
	opts_extend = { "sources.default" },
}

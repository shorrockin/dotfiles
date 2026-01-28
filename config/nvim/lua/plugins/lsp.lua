-- Native LSP configuration using vim.lsp.config and vim.lsp.enable
-- This is a config-only plugin with dependencies
return {
	dir = vim.fn.stdpath("config"), -- Makes this a local "plugin"
	name = "native-lsp-config",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
	},
	lazy = false,
	priority = 1000,
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap.
				map("H", vim.lsp.buf.hover, "Hover Documentation")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				-- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Custom :LspInfo command to replace nvim-lspconfig's version
		vim.api.nvim_create_user_command("LspInfo", function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local lines = {}

			if #clients == 0 then
				table.insert(lines, "No LSP clients attached to this buffer")
			else
				table.insert(lines, "LSP clients attached to this buffer:")
				table.insert(lines, "")
				for _, client in ipairs(clients) do
					table.insert(lines, string.format("  %s (id: %d)", client.name, client.id))
					table.insert(lines, string.format("    Root: %s", client.root_dir or "nil"))
					table.insert(lines, string.format("    Filetypes: %s", table.concat(client.config.filetypes or {}, ", ")))
					table.insert(lines, "")
				end
			end

			-- Also show all active clients (in other buffers)
			local all_clients = vim.lsp.get_clients()
			if #all_clients > #clients then
				table.insert(lines, "Other active LSP clients:")
				table.insert(lines, "")
				for _, client in ipairs(all_clients) do
					local attached = vim.tbl_contains(vim.tbl_map(function(c) return c.id end, clients), client.id)
					if not attached then
						table.insert(lines, string.format("  %s (id: %d)", client.name, client.id))
						table.insert(lines, string.format("    Root: %s", client.root_dir or "nil"))
						table.insert(lines, "")
					end
				end
			end

			-- Display in floating window
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modifiable = false

			local width = math.min(80, vim.o.columns - 4)
			local height = math.min(#lines + 2, vim.o.lines - 4)

			vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				col = math.floor((vim.o.columns - width) / 2),
				row = math.floor((vim.o.lines - height) / 2),
				style = "minimal",
				border = "rounded",
				title = " LSP Info ",
				title_pos = "center",
			})

			-- Close on q or <Esc>
			vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
			vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
		end, { desc = "Show LSP client information" })

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add blink.cmp, Neovim now has *more* capabilities.
		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

		-- Dynamically load all LSP configurations from lua/lsp/*.lua
		local lsp_configs = {}
		for _, file in pairs(vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)) do
			local server_name = vim.fn.fnamemodify(file, ":t:r")
			local ok, lsp_config = pcall(require, "lsp." .. server_name)
			if ok and lsp_config.name then
				-- Merge capabilities into the config
				local config = vim.tbl_deep_extend("force", {}, lsp_config.config or {})
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

				-- Register the LSP config (vim.lsp.config is a table in Neovim 0.11+)
				vim.lsp.config[lsp_config.name] = config

				-- Track server name for enabling
				table.insert(lsp_configs, lsp_config.name)
			end
		end

		-- Enable all loaded LSP servers using native vim.lsp.enable
		vim.lsp.enable(lsp_configs)
	end,
}

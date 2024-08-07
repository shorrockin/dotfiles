-- there's probably a better way to turn this off in the lsp config
-- but i couldn't find the correct incantation.
vim.diagnostic.config({
	virtual_text = false,
})

-- more narrow for markdown, maybe not the best idea with long urls,
-- makes a bit of a mess
-- vim.bo.textwidth = 160

-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt_local.foldenable = true
-- vim.opt_local.foldlevelstart = 99 -- Start with all folds open
-- vim.opt_local.foldnestmax = 10 -- Maximum fold levels

-- set's markdown indentation to 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- folds things like urls, etc
vim.opt_local.conceallevel = 2

-- Snippets below
local ls = require("luasnip")
local snippet = ls.snippet
local snippet_node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local dynamic = ls.dynamic_node

-- some common macros across a variety of markdown files
vim.api.nvim_exec2(
	[[
  let @d = "0f i ✅\x1b"
  let @s = "0f i 😴\x1b"
  let @m = "0f i ↪️\x1b"
  let @r = "0f i 🔄\x1b"
  let @c = "0f[lrx<80><fd>5$"
]],
	{ output = false }
)

vim.keymap.set("n", "<leader>id", function()
	vim.api.nvim_put({ os.date("%Y-%m-%d") }, "c", true, true)
end, { desc = "Markdown: [I]nsert [D]ate" })

local name = function(trigger, name, description)
	return {
		trig = trigger,
		name = name,
		dscr = description,
	}
end

local extract_path_for_markdown_text = function(args)
	local url = args[1][1] or ""
	-- Match any character sequence after the last /
	local path = url:match("^.+/(.+)$") or url
	-- Remove any trailing query parameters
	local clean_path = path:gsub("%?.*$", "")

	return snippet_node(nil, { text(clean_path) })
end

ls.add_snippets("markdown", {
	-- normal link
	ls.parser.parse_snippet(name("nl", "Normal Link", "Inserts a normal mardown link"), "[${1}](${2})"),

	-- easy link
	snippet(name("el", "Easy Link", "Inserts a generating the name based on the url suffix"), {
		text("["),
		dynamic(2, extract_path_for_markdown_text, { 1 }),
		text("]("),
		insert(1, "http://url.com?params=true"),
		text(")"),
	}),
})

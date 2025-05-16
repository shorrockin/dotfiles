local ls = require("luasnip")
-- local snippet = ls.snippet
-- local text = ls.text_node
-- local insert = ls.insert_node
-- local rep = require("luasnip.extras").rep
-- local fmt = require("luasnip.extras.fmt").fmt
-- local c = ls.choice_node

ls.add_snippets("lua", {
	ls.parser.parse_snippet("ps", 'print(string.format("${1}"))'),
	ls.parser.parse_snippet("dbg", "print(vim.inspect(${1}))"),
})

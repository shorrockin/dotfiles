return {
	-- https://github.com/iamcco/markdown-preview.nvim
	-- allows simple markdown rendering on the screen
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	enabled = false,
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
}

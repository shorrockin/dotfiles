return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			stages = "fade",
			render = "minimal",
			top_down = false,
		})
		vim.notify = notify
	end,
}

return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			stages = "fade",
			render = "minimal",
			top_down = false,
			background_colour = "#000000",
		})
		vim.notify = notify
	end,
}

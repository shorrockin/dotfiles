return {
	-- LuaLine: https://github.com/nvim-lualine/lualine.nvim - status line
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local macro_recording = function(str)
			local recording_register = vim.fn.reg_recording()
			if recording_register ~= "" then
				return str .. " (MACRO: " .. recording_register .. ")"
			else
				return str
			end
		end
		require("lualine").setup({
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return macro_recording(str)
						end,
					},
				},
			},
			options = {
				theme = "catppuccin",
				-- ... the rest of your lualine config
			},
		})
	end,
}

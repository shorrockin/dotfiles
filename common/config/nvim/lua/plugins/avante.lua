return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = "make",
	enabled = false,
	opts = {
		provider = "claude",
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-20250514",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
			-- provider = "ollama",
			-- providers = {
				-- 	ollama = {
					-- 		endpoint = "http://127.0.0.1:11434", 
					-- 		model = "gemma3",
					-- 	},
					-- },
				},
			}
		}

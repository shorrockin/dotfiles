return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	opts = {
		provider = "ollama",
		providers = {
			ollama = {
				endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
				model = "qwen3-coder:latest",
			},
		},
	},
}

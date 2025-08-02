return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = "make",
	enabled = false,
	opts = {
		provider = "ollama",
		providers = {
			ollama = {
				endpoint = "http://127.0.0.1:11434", 
				model = "gemma3",
			},
		},
	},
}

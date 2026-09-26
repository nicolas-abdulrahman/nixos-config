-- In your init.lua or plugins/codecompanion.lua
require("codecompanion").setup({
	strategies = {
		chat = { adapter = "gemini" },
		inline = { adapter = "gemini" },
		agent = { adapter = "gemini" },
	},
	adapters = {
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				env = {
					api_key = "AIzaSyBFM6qm8HopurT5NU-TDPYuE1XPU3RYdm4",
				},
				schema = {
					model = {
						default = "gemini-2.0-flash",
					},
				},
			})
		end,
	},
	-- optional nice defaults
	display = {
		chat = {
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		nix = { "nixpkgs_fmt", stop_after_first = true },
		typescript = { "prettier" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		html = { "prettierd", "htmlbeautifier", "superhtml", "js-beautify", "tidy", stop_after_first = true },
		css = { "js-beautify", "tidy", "prettierd", stop_after_first = true },
		markdown = { "prettierd" },
	},
	formatters = {
		prettierd = {
			env = {
				endOfLine = "lf",
				insertPragma = false,
				requirePragma = false,
				trailingComma = "all",
				tabWidth = 2,
				useTabs = false,
				singleQuote = true,
				printWidth = 9999,
				functionCallArgumentNewlines = "none",
				functionParenthesis = "min",
			},
		},
		stylua = {
			prepend_args = { "--column-width", "9999" },
		},
	},
})
vim.keymap.set({ "n", "v" }, "<leader>pp", function()
	require("conform").format({
		lsp_format = "fallback",
		async = true,
		timeout_ms = 500,
	})
end, { desc = "Format file or visual selection range" })

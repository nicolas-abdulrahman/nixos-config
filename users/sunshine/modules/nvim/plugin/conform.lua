require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		html = { "htmlbeautifier", "superhtml", "js-beautify", "tidy", "prettierd", stop_after_first = true },
		css = { "js-beautify", "tidy", "prettierd", stop_after_first = true },
		nix = { "nixpkgs_fmt", stop_after_first = true },
		typescript = { "prettier" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" }, -- for .tsx
		json = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		markdown = { "prettierd" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
	-- If this is set, Conform will run the formatter asynchronously after save.
	-- It will pass the table to conform.format().
	-- This can also be a function that returns the table.
	format_after_save = {
		lsp_format = "fallback",
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

				printWidth = 120,
				functionCallArgumentNewlines = "none",
				functionParenthesis = "min",
			},
		},
	},
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- pattern = "*",
-- callback = function(args)
-- require("conform").format({ bufnr = args.buf })
-- end,
-- })

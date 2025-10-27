require("nvim-treesitter.configs").setup({
	ensure_installed = {},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

vim.filetype.add({
	extension = {
		ejs = "html",
	},
})

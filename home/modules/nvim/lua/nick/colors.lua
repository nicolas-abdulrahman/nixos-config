require("catppuccin").setup({
	flavour = "mocha",
})

function Colorize(color)
	-- color = color or "tokyonight"
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	-- vim.cmd('highlight LineNr guifg=#42b4fc')

	-- vim.cmd([[highlight LineNr ctermfg=#ffec1e guifg=green ctermbg=none guibg=none]])
	vim.cmd([[highlight SignColumn guibg=none]])
end

Colorize()

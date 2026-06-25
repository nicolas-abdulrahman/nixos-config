vim.o.foldenable = true
vim.o.foldcolumn = '1'           -- Disable built‑in fold column (statuscol replaces it)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.require'ufo'.getFolds(v:lnum)"

vim.opt.fillchars:append({
        foldopen = "▼",
        foldclose = "▶",
        fold = " ",          -- Removes the ugly dots/dashes linking lines
        foldsep = " ",        -- Removes vertical depth separation lines
      })

-- BEAUTIFUL VIRTUAL TEXT RENDERER
local customize_fold_text = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ("  ··· %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			table.insert(newVirtText, { chunkText, chunk[2] })
			curWidth = curWidth + vim.fn.strdisplaywidth(chunkText)
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "Comment" })
	return newVirtText
end

require("ufo").setup({
	fold_virt_text_handler = customize_fold_text,
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})

vim.keymap.set('n', 'zP', function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end, { desc = "UFO: Peek Fold" })


local augroup = vim.api.nvim_create_augroup("autocmd.eww", { clear = true })
eww = {
	pattern = "eww",
	group = augroup,
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
}
function setup(opts)
	print("hii")
	vim.api.nvim_create_autocmd("FileType", eww)
end
return { setup = setup }

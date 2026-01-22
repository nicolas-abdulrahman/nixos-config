vim.keymap.set("v", "<leader>rr", function()
	-- Ask for input
	local from = vim.fn.input("Replace what: ")
	if from == "" then
		return
	end

	local to = vim.fn.input("Replace with: ")

	-- Escape special characters so plain text works
	from = vim.fn.escape(from, "[[/.*$^~[]]]")
	to = vim.fn.escape(to, [[\/]])

	-- Run substitute on visual selection
	vim.cmd(string.format("'<,'>s/%s/%s/g", from, to))
end, {
	silent = true,
	desc = "Prompted replace in selection",
})
vim.keymap.set("v", "<leader>rw", function()
	local from = vim.fn.input("Replace wrapper  {}, [], (): ")
	if from == "" then
		return
	end
	local to = vim.fn.input(string.format("Replace %s with {}, [], (), : ", from:sub(1, 1)))
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getpos(".")
	local srow, scol = start[2], start[3]
	local erow, ecol = finish[2], finish[3]
	local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
	local special_chars = "^$(["

	for i, line in ipairs(lines) do
		local l = line
		l = l:gsub(escape_special(from) .. from:sub(1, 1), to:sub(1, 1))
		l = l:gsub(escape_special(from) .. from:sub(2, 2), to:sub(2, 2))
		lines[i] = l
	end

	vim.api.nvim_buf_set_lines(0, srow - 1, erow, false, lines)
end, {
	silent = true,
	desc = "Prompted replace in selection",
})

function escape_special(str, special_char)
	special_char = special_char or "%"
	local special_chars = "^$(["
	for char in special_chars:gmatch(".") do
		if string.find(str, char) then
			return special_char
		end
	end
	return ""
end

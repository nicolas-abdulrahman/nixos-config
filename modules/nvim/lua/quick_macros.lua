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




vim.keymap.set("v", "r", function()
	vim.cmd('normal! "vy')
	local selected_text = vim.fn.getreg("v")
	local escaped_text = vim.fn.escape(selected_text, [[\/^*$~[]])
	if string.find(selected_text, "\n") then
		vim.notify("Can't replace multipe lines", vim.log.levels.INFO)
		return
	end
	if escaped_text == "" then
		return
	end

	vim.ui.input({
		prompt = "Replace selection with: ",
		default = selected_text,
	}, function(input)
		if not input or input == "" or input == selected_text then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local pattern = selected_text:gsub("([^%w])", "%%%1")

		for i, line in ipairs(lines) do
			lines[i] = string.gsub(line, pattern, input)
		end

		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		print(string.format('Successfully replaced all occurrences with "%s"', input))
	end)
end, { desc = "Interactively replace visual selection file-wide" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
	desc = "LSP Rename symbol project-wide",
})
vim.keymap.set("v", "<leader>w", function()
    -- 1. Force a yank of the current visual selection into register "x before doing anything else
    vim.cmd([[normal! "xy]])

    local pairs = {
        ["("] = { "(", ")" }, [")"] = { "(", ")" },
        ["["] = { "[", "]" }, ["]"] = { "[", "]" },
        ["{"] = { "{", "}" }, ["}"] = { "{", "}" },
        ["<"] = { "<", ">" }, [">"] = { "<", ">" },
    }

    -- 2. Schedule the UI input so it doesn't collide with the visual state change
    vim.schedule(function()
        vim.ui.input({
            prompt = "Wrap selection with: ",
        }, function(input)
            if not input or input == "" then
                return
            end

            -- 3. Determine opening and closing characters
            local open_char, close_char = input, input
            if pairs[input] then
                open_char, close_char = pairs[input][1], pairs[input][2]
            end

            -- 4. Re-select the area where the selection *was* and change it
            -- We use `gv` to bring back the visual selection, then `c` to change it
            local macro = "gv" .. "c" .. open_char .. '<C-r>x' .. close_char .. "<Esc>v`[v`]"
            local keys = vim.api.nvim_replace_termcodes(macro, true, false, true)
            
            vim.api.nvim_feedkeys(keys, "n", false)
        end)
    end)
end, { desc = "Wrap visual selection with text box dialog" })

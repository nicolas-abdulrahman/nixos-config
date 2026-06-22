vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pe", vim.cmd.Ex)
vim.api.nvim_set_keymap("n", "<C-s>", ":wa!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "ss", ":wa!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>s", ":wa!<CR>", { noremap = true })

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "so", function()
	vim.cmd("wa!")
	vim.cmd("so")
	vim.notify("sourced")
end, opts)
vim.api.nvim_create_user_command("ReplaceSelection", function()
	-- Save the selected text to a variable
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	if #lines == 0 then
		return
	end

	-- Extract the actual selected text
	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_col, end_col)
	else
		lines[1] = string.sub(lines[1], start_col)
		lines[#lines] = string.sub(lines[#lines], 1, end_col)
	end

	local selected_text = table.concat(lines, "\n")
	selected_text = vim.fn.escape(selected_text, "\\/") -- Escape for safe substitution

	-- Ask for the replacement
	local replacement = vim.fn.input('Replace "' .. selected_text .. '" with: ')
	-- if replacement == "" then
	-- return
	-- end

	-- Do the replacement in the whole buffer
	vim.cmd(string.format("%%s/\\V%s/%s/g", selected_text, replacement))
end, { range = true })

vim.keymap.set("v", "<leader>rr", ":ReplaceSelection<CR>")

function ren(line)
	local word = vim.fn.expand("<cword>")
	local new_name = vim.fn.input("Rename '" .. word .. "' to: ")

	if new_name == "" or new_name == word then
		print("No change made.")
		return
	end

	-- Do a whole word replacement in the current buffer
	local escaped = vim.fn.escape(word, "\\/.*'$^~[]") -- escape Lua pattern chars
	if line == false then
		vim.cmd(":%s/\\<" .. escaped .. "\\>/" .. new_name .. "/g")
	else
		vim.cmd(":.s/\\<" .. escaped .. "\\>/" .. new_name .. "/g")
	end
end
vim.api.nvim_create_user_command("RenameWord", function()
	ren(false)
end, {})
vim.api.nvim_create_user_command("RenameLine", function()
	ren(true)
end, {})
-- my setup
vim.keymap.set("v", "<Tab>", "> | gv")
vim.keymap.set("v", "<S-Tab>", "< | gv")
vim.keymap.set("t", "<A-Space>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<A-j>", ":cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":cprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-d>", function()
	local qflist = vim.fn.getqflist()
	local idx = vim.fn.getqflist({ idx = 0 }).idx
	table.remove(qflist, idx)
	vim.fn.setqflist(qflist, "r")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cra", "<cmd>RenameWord<CR>", { desc = "Rename word under cursor" })
vim.keymap.set("n", "<leader>crl", "<cmd>RenameLine<CR>", { desc = "Rename word under cursor" })

-- the Primagean setup
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- greatest remap ever
vim.keymap.set("x", "<leader>dd", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Create a horizontal splitader>/', ':vsplit<CR>', { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>-", ":split<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>/", ":vsplit<CR>", { noremap = true })

-- PLUGINS
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", vim.cmd.CommentToggle, { silent = true })
vim.keymap.set("v", "<S-h>", ":'<,'>CommentToggle<CR>", { silent = true })
vim.cmd(":tnoremap <Esc> <C-\\><C-n>")

-- QUICKFIX
vim.keymap.set("n", "qj", "<cmd>cnext<CR>", { silent = true })
vim.keymap.set("n", "qk", "<cmd>cprev<CR>", { silent = true })
vim.keymap.set("n", "qq", "<cmd>ccl<CR>", { silent = true })

-- BUFFERS
vim.keymap.set("n", "ter", "<cmd>:term<CR>", { silent = true })
vim.keymap.set("n", "na", "<cmd>%bwipeout!<CR>", { silent = true })
vim.keymap.set("n", "nn", "<cmd>bdelete!<CR>", { silent = true })
-- vim.keymap.set("n", "n", "<cmd>bdelete!<CR>" , { silent = true })

vim.keymap.set("n", "cd", "<cmd>cd %:h<CR>", { silent = true })
vim.keymap.set("n", "ctd", "<cmd>tcd %:h<CR>", { silent = true })
vim.keymap.set("n", "cld", "<cmd>lcd %:h<CR>", { silent = true })

-- vim.keymap.set("n", "<A-a>", "<C-S-w>_", { silent = true })
vim.keymap.set("n", "<A-a>", "<C-S-w>|", { silent = true })
vim.keymap.set("n", "<A-s>", "<C-S-w>=", { silent = true })

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<A-t>", function()
	local results = {}
	local picker = telescope.buffers()
	local s = ""

	-- Capture the results from the picker
	picker.entry_manager:get_entries(function(entry)
		s = s .. "|"
		print(s)

		-- table.insert(results, entry.value)
	end)
end, { silent = true })

vim.keymap.set("v", "<leader>w", function()
	local char = vim.fn.getcharstr()
	local pairs = {
		["("] = { "(", ")" },
		[")"] = { "(", ")" },
		["["] = { "[", "]" },
		["]"] = { "[", "]" },
		["{"] = { "{", "}" },
		["}"] = { "{", "}" },
		["<"] = { "<", ">" },
		[">"] = { "<", ">" },
	}

	local open_char, close_char = char, char
	if pairs[char] then
		open_char, close_char = pairs[char][1], pairs[char][2]
	end

	local keys = vim.api.nvim_replace_termcodes("c" .. open_char .. '<C-r>"' .. close_char .. "<Esc>v`[v`]", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end, { desc = "Wrap visual selection with next char" })

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

		-- 3. Pure Lua Buffer Manipulation (No Vim commands to break)
		local bufnr = vim.api.nvim_get_current_buf()
		-- Pull every single line in the current file
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

		-- Escape raw text into a strict, clean Lua search pattern
		-- (This makes sure characters like ., -, +, *, etc., don't break things)
		local pattern = selected_text:gsub("([^%w])", "%%%1")

		-- Loop through the lines and execute the replacement
		for i, line in ipairs(lines) do
			lines[i] = string.gsub(line, pattern, input)
		end

		-- Write the altered lines back to your screen instantly
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

		print(string.format('Successfully replaced all occurrences with "%s"', input))
	end)
end, { desc = "Interactively replace visual selection file-wide" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
	desc = "LSP Rename symbol project-wide",
})

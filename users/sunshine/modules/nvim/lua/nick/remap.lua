vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pe", vim.cmd.Ex)
vim.api.nvim_set_keymap("n", "<C-s>", ":wa!<CR>", { noremap = true })

vim.keymap.set("n", "so", "<cmd>so<CR>", opts)
-- vim.keymap.set("n", ">", "> | gv")
--
-- my setup
vim.keymap.set("v", "<Tab>", "> | gv")
vim.keymap.set("v", "<S-Tab>", "< | gv")
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

-- TABS

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

vim.o.tabline = "%!v:lua.MyTabLine()"

local telescope = require("telescope.builtin")

function MyTabLine()
	local buffers = vim.api.nvim_list_bufs()
	local s = ""

	-- Iterate through each buffer and filter active ones
	for _, buf in ipairs(buffers) do
		-- Check if the buffer is loaded and listed
		if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 then
			-- Get the buffer's file name and number
			local buf_name = vim.api.nvim_buf_get_name(buf)
			local buf_number = vim.api.nvim_buf_get_number(buf)
			s = s .. "|" .. tostring(buf_number)
			tostring(buf_number)
			-- Print the buffer number and name
			-- print("Active Buffer " .. buf_number .. ": " .. buf_name)
		end
	end
	return s
end

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

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


local function next_buffer()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local cur = vim.fn.bufnr('%')
  local idx = nil
  for i, b in ipairs(bufs) do
    if b.bufnr == cur then idx = i; break end
  end
  if idx == nil then return end
  local next_idx = idx + 1
  if next_idx > #bufs then
    vim.notify("Already at last buffer")

    return
  end
  vim.cmd('buffer ' .. bufs[next_idx].bufnr)
end

local function prev_buffer()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local cur = vim.fn.bufnr('%')
  local idx = nil
  for i, b in ipairs(bufs) do
    if b.bufnr == cur then idx = i; break end
  end
  if idx == nil then return end
  local prev_idx = idx - 1
  if prev_idx < 1 then
    vim.notify("Already at first buffer")
    return
  end
  vim.cmd('buffer ' .. bufs[prev_idx].bufnr)
end

vim.keymap.set('n', '<Tab>', ':b#<CR>', { desc = 'Toggle alternate buffer' })
vim.keymap.set('n', '<S-Tab>', prev_buffer, { desc = 'Previous buffer' })
vim.keymap.set('n', '<M-Tab>', next_buffer, { desc = 'Next buffer' })

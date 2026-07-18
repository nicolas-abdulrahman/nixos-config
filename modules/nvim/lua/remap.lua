vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- Helper function to automatically inject descriptions into base opts
local function M(desc_string)
    return vim.tbl_extend("force", opts, { desc = desc_string })
end

-- GLOBAL ACTIONS & SAVING
vim.keymap.set("n", "<leader>pe", "<cmd>Ex<CR>", M("Open file explorer"))
vim.keymap.set("n", "<C-s>", ":wa!<CR>", M("Save all files"))
vim.keymap.set("n", "ss", ":wa!<CR>", M("Save all files alternative"))
vim.keymap.set("n", "<leader>s", ":wa!<CR>", M("Leader save all files"))
vim.keymap.set("n", "<leader>so", function()
    vim.cmd("wa!")
    vim.cmd("so")
    vim.notify("sourced")
end, M("Save and source configuration"))
vim.keymap.set("n", "<leader>qa", "<cmd>qa!<cr>", M("Force quit all"))

-- EDITING & INDENTATION
vim.keymap.set("v", "<Tab>", ">gv", M("Indent selection right"))
vim.keymap.set("v", "<S-Tab>", "<gv", M("Indent selection left"))
vim.keymap.set("t", "<A-Space>", [[<C-\><C-n>]], M("Exit terminal mode"))
vim.keymap.set("n", "<A-j>", ":cnext<CR>", M("Next quickfix item"))
vim.keymap.set("n", "<A-k>", ":cprev<CR>", M("Previous quickfix item"))
vim.keymap.set("n", "<A-d>", function()
    local qflist = vim.fn.getqflist()
    local idx = vim.fn.getqflist({ idx = 0 }).idx
    table.remove(qflist, idx)
    vim.fn.setqflist(qflist, "r")
end, M("Delete current quickfix item"))

-- LINE MOVEMENTS
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", M("Move selected lines down"))
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", M("Move selected lines up"))
vim.keymap.set("n", "J", "mzJ`z", M("Join line keeping cursor position"))
vim.keymap.set("n", "<C-d>", "<C-d>zz", M("Scroll down and center cursor"))
vim.keymap.set("n", "<C-u>", "<C-u>zz", M("Scroll up and center cursor"))
vim.keymap.set("x", "<leader>dd", [["_dP]], M("Paste over selection without losing register"))

-- INTEGRATED SEARCH JUMPS (Centering + hlslens refresh)

-- REGISTERS, CLIPPINGS & MACROS
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], M("Copy to system clipboard"))
vim.keymap.set("n", "<leader>Y", [["+Y]], M("Copy line to system clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], M("Delete into black hole register"))
vim.keymap.set("n", "Q", "<nop>", M("Disable Ex mode shortcut"))
vim.keymap.set("n", "q", "<nop>", M("Disable macro recording key"))
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], M("Search and replace word under cursor"))
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", M("Make current file executable"))

-- WINDOW NAVIGATION & SPLITS
vim.keymap.set("n", "<C-h>", "<C-w>h", M("Move cursor to left split"))
vim.keymap.set("n", "<C-l>", "<C-w>l", M("Move cursor to right split"))
vim.keymap.set("n", "<C-k>", "<C-w>k", M("Move cursor to upper split"))
vim.keymap.set("n", "<C-j>", "<C-w>j", M("Move cursor to lower split"))
vim.keymap.set("n", "<leader>-", ":split<CR>", M("Create horizontal split"))
vim.keymap.set("n", "<leader>/", ":vsplit<CR>", M("Create vertical split"))

-- PLUGIN MANAGEMENT
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", M("Toggle file tree sidebar"))
vim.keymap.set("n", "<S-h>", "<cmd>CommentToggle<CR>", M("Toggle line comment"))
vim.keymap.set("v", "<S-h>", ":'<,'>CommentToggle<CR>", M("Toggle visual selection comment"))
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], M("Terminal mode escape to normal"))

-- QUICKFIX ACTIONS
vim.keymap.set("n", "qj", "<cmd>cnext<CR>", M("Quickfix next shortcut"))
vim.keymap.set("n", "qk", "<cmd>cprev<CR>", M("Quickfix previous shortcut"))
vim.keymap.set("n", "qq", "<cmd>ccl<CR>", M("Close quickfix window"))

-- BUFFERS & TERMINALS
vim.keymap.set("n", "ter", "<cmd>:term<CR>", M("Open terminal buffer"))
vim.keymap.set("n", "<leader>ba", "<cmd>%bwipeout!<CR>", M("Wipe all listed buffers"))
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete!<CR>", M("Delete current buffer"))

-- ENVIRONMENT & DIRECTORIES
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR>", M("Change global directory to current file"))
vim.keymap.set("n", "<leader>cD", "<cmd>tcd %:h<CR>", M("Change tab directory to current file"))
vim.keymap.set("n", "<leader><C-d>", "<cmd>lcd %:h<CR>", M("Change local window directory to current file"))

-- WINDOW DIMENSIONS
vim.keymap.set("n", "<A-a>", "<C-S-w>|", M("Maximize current split width"))
vim.keymap.set("n", "<A-s>", "<C-S-w>=", M("Equalize all split dimensions"))

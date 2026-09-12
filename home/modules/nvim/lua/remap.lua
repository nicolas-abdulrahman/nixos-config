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
vim.keymap.set("n", "<S-h>", "gcc", { remap = true, desc = "Toggle line comment" })
vim.keymap.set("v", "<S-h>", "gc", { remap = true, desc = "Toggle visual selection comment" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], M("Terminal mode escape to normal"))


-- BUFFERS & TERMINALS
vim.keymap.set("n", "ter", "<cmd>:term<CR>", M("Open terminal buffer"))
vim.keymap.set("n", "<leader>ba", "<cmd>%bwipeout!<CR>", M("Wipe all listed buffers"))
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete!<CR>", M("Delete current buffer"))

-- ENVIRONMENT & DIRECTORIES
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR>", M("Change global directory to current file"))
vim.keymap.set("n", "<leader>cD", "<cmd>tcd %:h<CR>", M("Change tab directory to current file"))
vim.keymap.set("n", "<leader><C-d>", "<cmd>lcd %:h<CR>", M("Change local window directory to current file"))

-- WINDOW DIMENSIONS
vim.keymap.set("n", "<A-S-a>", "<C-S-w>|", M("Maximize current split width"))
vim.keymap.set("n", "<A-S-s>", "<C-S-w>=", M("Equalize all split dimensions"))



-- DELETE stuff

vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line to black hole" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete char to black hole" })

local function cut_to_clipboard()
    local mode = vim.fn.mode()
    if mode:match("[vV\22]") then
        -- Visual mode: yank selection to "+, then delete selection
        return '"+d'
    else
        -- Normal mode: operator-pending cut
        -- Using "+d will populate both the "+ register and the unnamed register
        return '"+d'
    end
end

vim.keymap.set({ "n", "v" }, "<leader>d", cut_to_clipboard, { expr = true, desc = "Cut to clipboard & unnamed register" })
vim.keymap.set("n", "<leader>dd", '"+dd', { desc = "Cut entire line to clipboard" })
vim.keymap.set("n", "<leader>D", '"+D',   { desc = "Cut to end of line to clipboard" })



-- QUICKFIX

-- -- Alt+A: Toggle Quickfix window open/close
vim.keymap.set("n", "<M-z>", function()
  local qf_exists = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix window" })


vim.keymap.set("n", "<M-a>", "<cmd>colder<CR>", { desc = "Older quickfix list" })
vim.keymap.set("n", "<M-d>", "<cmd>cnewer<CR>", { desc = "Newer quickfix list" })
-- Alt+S: Jump to NEXT quickfix item (wraps to start at the end)
vim.keymap.set("n", "<M-s>", function()
  local ok = pcall(vim.cmd, "cnext")
  if not ok then
    pcall(vim.cmd, "cfirst")
  end
end, { desc = "Quickfix next item" })

-- Alt+W: Jump to PREVIOUS quickfix item (wraps to end at the start)
vim.keymap.set("n", "<M-w>", function()
  local ok = pcall(vim.cmd, "cprev")
  if not ok then
    pcall(vim.cmd, "clast")
  end
end, { desc = "Quickfix previous item" })





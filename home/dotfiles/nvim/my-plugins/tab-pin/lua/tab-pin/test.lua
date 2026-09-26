-- Add the current directory to package.path so require works cleanly
local current_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
package.path = current_dir .. "/?.lua;" .. current_dir .. "/?/init.lua;" .. package.path

local tab_pin = require("init")

tab_pin.setup({
    debug = true
})

local map = vim.keymap.set
local opts = { silent = true }

-- Tab Navigation & Lifecycle (Default Vim commands)
map("n", "<M-h>", "<cmd>tabprevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous tab" }))
map("n", "<M-l>", "<cmd>tabnext<CR>",     vim.tbl_extend("force", opts, { desc = "Next tab" }))
map("n", "<M-q>", "<cmd>tabclose<CR>",    vim.tbl_extend("force", opts, { desc = "Close tab" }))
map("n", "<M-n>", "<cmd>tabnew<CR>",      { silent = true, desc = "New tab" })

-- TabPin Operations
map("n", "<M-p>", "<cmd>TabPinToggle<CR>", vim.tbl_extend("force", opts, { desc = "TabPin: Toggle pin" }))
map("n", "<M-s>", "<cmd>TabPinSave<CR>",   vim.tbl_extend("force", opts, { desc = "TabPin: Save pins" }))

-- Collision note: Changed Alt+l (Load) to Alt+o to keep Alt+l for Next Tab
map("n", "<M-o>", "<cmd>TabPinLoad<CR>",   vim.tbl_extend("force", opts, { desc = "TabPin: Load pins" }))


map("n", "<M-n>", "<cmd>tabnew<CR>",      { silent = true, desc = "New tab" })
map("n", "<M-q>", "<cmd>tabclose<CR>", { silent = true, desc = "Close tab" })

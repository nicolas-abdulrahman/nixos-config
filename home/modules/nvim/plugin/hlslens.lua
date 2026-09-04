-- ==========================================================================
-- OFFICIAL HLSLENS SETUP + EXPLICIT / REMAP
-- ==========================================================================

-- 1. Setup with official settings
require('hlslens').setup({
    calm_down = true,
    nearest_only = false,
    nearest_float_when_around = true
})

-- 2. Vibrant Color Overrides (Ensures they are bright and visible)
local api = vim.api
api.nvim_set_hl(0, 'HlSearchLens', { fg = '#ffffff', bg = '#800080', bold = true })
api.nvim_set_hl(0, 'HlSearchLensNear', { fg = '#000000', bg = '#ff007f', bold = true })

-- 3. EXPLICIT / REMAP (Triggers hlslens calculations in real-time as you type)
vim.keymap.set('n', '/', function()
    -- Open the native forward search line
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('/', true, true, true), 'n', true)
    
    -- Schedule a real-time listener that forces hlslens to render matches immediately
    vim.schedule(function()
        vim.api.nvim_create_autocmd('CmdlineChanged', {
            group = vim.api.nvim_create_augroup('HlslensLive', { clear = true }),
            pattern = '/',
            callback = function()
                pcall(require('hlslens').start)
            end,
        })
    end)
end, { desc = "Live interactive search forward" })

-- Clean up the live listener group as soon as you exit the search bar
vim.api.nvim_create_autocmd('CmdlineLeave', {
    pattern = '/',
    callback = function()
        pcall(function() vim.api.nvim_del_augroup_by_name('HlslensLive') end)
    end,
})

-- 4. Official Next/Previous Keymaps
local kopts = {silent = true, expr = true}
vim.keymap.set('n', 'n', function()
    return vim.v.searchforward == 1 and 'n<Cmd>lua require("hlslens").start()<CR>' or 'N<Cmd>lua require("hlslens").start()<CR>'
end, kopts)

vim.keymap.set('n', 'N', function()
    return vim.v.searchforward == 1 and 'N<Cmd>lua require("hlslens").start()<CR>' or 'n<Cmd>lua require("hlslens").start()<CR>'
end, kopts)

-- Clear highlights on Esc
vim.keymap.set('n', '<Esc>', '<Cmd>nohsplit<CR><Cmd>lua require("hlslens").stop()<CR><Esc>', {silent = true})


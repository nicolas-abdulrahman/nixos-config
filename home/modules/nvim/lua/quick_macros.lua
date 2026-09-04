-- ADVANCED SELECTION UTILITIES

-- Helper local function for regex pattern escaping
local function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

-- Prompted string replacement inside visual selections
vim.keymap.set("v", "<leader>rr", function()
    local from = vim.fn.input("Replace what: ")
    if from == "" then return end
    local to = vim.fn.input("Replace with: ")
    from = vim.fn.escape(from, "[[/.*$^~[]]]")
    to = vim.fn.escape(to, [[\/]])
    vim.cmd(string.format("'<,'>s/%s/%s/g", from, to))
end, { silent = true, desc = "Prompted regex replace in selection" })

-- Swaps surrounding bracket formats on selected rows
vim.keymap.set("v", "<leader>rb", function()
    local from = vim.fn.input("Replace wrapper {}, [], (): ")
    if from == "" or #from < 2 then return end
    local to = vim.fn.input("Replace with {}, [], (): ")
    if to == "" or #to < 2 then return end

    local start = vim.fn.getpos("v")
    local finish = vim.fn.getpos(".")
    local srow, erow = math.min(start[2], finish[2]), math.max(start[2], finish[2])
    local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)

    for i, line in ipairs(lines) do
        local l = line
        l = l:gsub(escape_pattern(from:sub(1,1)), to:sub(1,1))
        l = l:gsub(escape_pattern(from:sub(2,2)), to:sub(2,2))
        lines[i] = l
    end
    vim.api.nvim_buf_set_lines(0, srow - 1, erow, false, lines)
end, { silent = true, desc = "Replace targeted surrounding brackets" })

-- Interactively replaces visual text selection global file-wide
vim.keymap.set("v", "<leader>rp", function()
    vim.cmd('normal! "vy')
    local selected_text = vim.fn.getreg("v")
    if string.find(selected_text, "\n") or selected_text == "" then return end

    vim.ui.input({ prompt = "Replace selection file-wide with: ", default = selected_text }, function(input)
        if not input or input == "" or input == selected_text then return end
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local pattern = escape_pattern(selected_text)
        for i, line in ipairs(lines) do lines[i] = string.gsub(line, pattern, input) end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end)
end, { desc = "File-wide replacement of selection match" })

-- Quick LSP rename call
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP Rename symbol project-wide" })

-- Wraps visual boundaries inside an input pair character matrix
vim.keymap.set("v", "<leader>w", function()
    vim.cmd([[normal! "xy]])
    local pairs = {
        ["("] = { "(", ")" }, [")"] = { "(", ")" },
        ["["] = { "[", "]" }, ["]"] = { "[", "]" },
        ["{"] = { "{", "}" }, ["}"] = { "{", "}" },
        ["<"] = { "<", ">" }, [">"] = { "<", ">" },
    }
    vim.schedule(function()
        vim.ui.input({ prompt = "Wrap selection with: " }, function(input)
            if not input or input == "" then return end
            local open_char, close_char = input, input
            if pairs[input] then open_char, close_char = pairs[input][1], pairs[input][2] end
            local macro = "gv" .. "c" .. open_char .. '<C-r>x' .. close_char .. "<Esc>"
            local keys = vim.api.nvim_replace_termcodes(macro, true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
        end)
    end)
end, { desc = "Wrap visual selection with match pair characters" })


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


vim.g.disable_autoformat = true
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
       html = { "prettierd", "htmlbeautifier", "superhtml", "js-beautify", stop_after_first = true },
        css = { "prettierd", "js-beautify", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "htmlbeautifier", "superhtml", "js-beautify", stop_after_first = true },
        css = { "prettierd", "js-beautify", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        nix = { "nixfmt", "nixpkgs_fmt", stop_after_first = true },
    },
    formatters = {
        prettierd = {
        prepend_args = {
    "--print-width", "9999",
                "--single-quote",
                "--tab-width", "2",
                "--trailing-comma", "all",
                "--end-of-line", "lf",
            },
        },
        prettier = {
            prepend_args = {
                "--print-width", "9999",
                "--single-quote",
                "--tab-width", "2",
                "--trailing-comma", "all",
                "--end-of-line", "lf",
            },
        },
        stylua = {
            prepend_args = { "--column-width", "9999" },
        },
    },
    format_on_save = function(bufnr)
        -- Disable autoformat if toggled off globally or per-buffer
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})

-- Format current buffer or visual selection (<leader>cf)
    -- Format entire buffer in Normal mode (<leader>cf)
    vim.keymap.set("n", "<leader>cf", function()
        require("conform").format({
            lsp_format = "fallback",
            async = false,
            timeout_ms = 1000,
        })
    end, { desc = "Format entire buffer" })

    -- Format ONLY visual selection when pressing 'c' in Visual mode (v, V, or Ctrl-V)
    vim.keymap.set("x", "c", function()
        local v_start = vim.fn.getpos("v")
        local v_end = vim.fn.getpos(".")
        local start_lnum = math.min(v_start[2], v_end[2])
        local end_lnum = math.max(v_start[2], v_end[2])
        local end_line = vim.fn.getline(end_lnum)

        require("conform").format({
            range = {
                start = { start_lnum, 0 },
                ["end"] = { end_lnum, string.len(end_line) },
            },
            lsp_format = "fallback",
            async = false,
            timeout_ms = 1000,
        })

        -- Exit visual mode back to normal mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end, { desc = "Format selected visual range with conform" })

    -- Toggle autoformat on save (Ctrl+Shift+C, Alt+C, or <leader>cs)
    local function toggle_autoformat()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        local state = vim.g.disable_autoformat and "disabled" or "enabled"
        vim.notify("Autoformat on save " .. state, vim.log.levels.INFO)
    
    end

    -- WezTerm by default intercepts Ctrl+Shift+C for clipboard copy,
    -- so <M-c> (Alt+c) and <leader>cs are included as guaranteed fallbacks!
    vim.keymap.set({ "n", "x" }, "<C-S-c>", toggle_autoformat, { desc = "Toggle autoformat on save" })
    vim.keymap.set({ "n", "x" }, "<C-S-C>", toggle_autoformat, { desc = "Toggle autoformat on save" })

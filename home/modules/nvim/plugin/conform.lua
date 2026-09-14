vim.g.disable_autoformat = true
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
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
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
require("conform").format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format buffer or visual range" })

-- Toggle autoformat on save (<leader>cs)
vim.keymap.set("n", "<leader>cs", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    local state = vim.g.disable_autoformat and "disabled" or "enabled"
    vim.notify("Autoformat on save " .. state, vim.log.levels.INFO)
end, { desc = "Toggle autoformat on save globally" })

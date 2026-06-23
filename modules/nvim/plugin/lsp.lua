vim.g.mapleader = " "

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-m>"] = cmp.mapping.scroll_docs(-4),
        ["<C-,>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
    }, {
        { name = "buffer" },
    }),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local status_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
    capabilities = cmp_lsp.default_capabilities()
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.api.nvim_set_keymap("n", "<leader>cjr", "JavaRunnerRunMain", { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>cjb", "JavaBuildBuildWorkspace", { noremap = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<C-d>", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>lsa", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lsr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<C-Space>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<S-Space>", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", opts)
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
    vim.keymap.set("n", "<S-h>", "<cmd>CommentToggle<CR>", opts)
end

vim.lsp.config("clangd", {
    cmd = { "/run/current-system/sw/bin/clangd", "-I/usr/include/qt", "-I/usr/include/qt/QtCore", "-I/usr/include/qt/QtWidgets" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
    cmd = { "/run/current-system/sw/bin/lua-lsp" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("nixd", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("zls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("gopls", {
    cmd = { os.getenv("GOPLS_PATH") },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("cssls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("html", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("css", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("cmake", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("jdtls", {
    cmd = { "jdtls" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("nil_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("gdscript", {
    -- Connects natively to Godot's running LSP server instance (default port 6005)
    cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
    filetypes = { "gdscript" },
    root_markers = { "project.godot", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config("sqls", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
        sqls = {
            connections = {
                {
                    driver = "mysql",
                    dataSourceName = "root:root@tcp(127.0.0.1:3306)/RuaSolidaria",
                },
            },
        },
    },
})

vim.lsp.enable({
    "clangd",
    "pyright",
    "ts_ls",
    "lua_ls",
    "nixd",
    "zls",
    "gopls",
    "cssls",
    "html",
    "css",
    "cmake",
    "jdtls",
    "nil_ls",
    "sqls",
})

local function concat_if_exist(path, path2)
    return path and (path .. path2) or nil
end

local lldb_exec = concat_if_exist(os.getenv("LLDB"), "/bin/lldb-vscode")
local dap = require("dap")

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = lldb_exec,
        args = { "--port", "${port}" },
    },
}

dap.configurations.rust = {
    {
        name = "Rust debug",
        type = "codelldb",
        request = "launch",
        program = function()
            vim.fn.jobstart("cargo build")
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        showDisassembly = "never",
    },
}


 local crates = require("crates")

crates.setup({
    -- Automatically reload information from crates.io when entering or editing a Cargo.toml buffer
    autoload = true,
    autoupdate = true,
    loading_indicator = true,
 })

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ", -- Heavy solid alert cross
            [vim.diagnostic.severity.WARN]  = "•", -- Clear warning triangle
            [vim.diagnostic.severity.HINT]  = "󰌵 ", -- Sleek glowing lightbulb
            [vim.diagnostic.severity.INFO]  = " ", -- Clean info circle
        },
    },
})

local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.api.nvim_set_keymap("n", "<leader>cjr", "JavaRunnerRunMain", { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>cjb", "JavaBuildBuildWorkspace", { noremap = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<C-d>", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "]<Right>", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)

    -- Previous diagnostic: [ + Right Arrow (or [<Left>)
    vim.keymap.set("n", "[<Right>", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader><leader>r", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader><leader>i", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader><leader>t", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<C-Space>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<S-Space>", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader><leader>d", "<cmd>Telescope diagnostics<CR>", opts)


    --------------------------------------------------------------------------------
    -- 2. Toggle Inlay Hints with <Space>h (Normal mode)
    --------------------------------------------------------------------------------
    vim.keymap.set("n", "<leader>h", function()
        if vim.lsp.inlay_hint then
            local current_buf = 0 -- 0 refers to the current active buffer
            local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = current_buf })
            vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = current_buf })
        end
    end, { desc = "Toggle LSP Inlay Hints" })


end




vim.lsp.config("clangd", {
    cmd = { "/run/current-system/sw/bin/clangd", "-I/usr/include/qt", "-I/usr/include/qt/QtCore", "-I/usr/include/qt/QtWidgets" },
    on_attach = on_attach,
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    on_attach = on_attach,
})

vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = on_attach,
})

vim.lsp.config("lua_ls", {
    on_attach= on_attach,
      cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = {
        -- Tell the language server that 'vim' is a valid global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files for auto-completion
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("zls", {
    on_attach = on_attach,
})

vim.lsp.config("gopls", {
    on_attach = on_attach,
})

vim.lsp.config("cssls", {
    on_attach = on_attach,
})

vim.lsp.config("html", {
    on_attach = on_attach,
})

vim.lsp.config("css", {
    on_attach = on_attach,
})

vim.lsp.config("cmake", {
    on_attach = on_attach,
})

vim.lsp.config("jdtls", {
    cmd = { "jdtls" },
    on_attach = on_attach,
})

vim.lsp.config("nil_ls", {
    on_attach = on_attach,
})


vim.lsp.config("sqls", {
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
    "html",
    "css",
    "cmake",
    "jdtls",
    "nil_ls",
    "sqls",
    "gdscript",
    "rust_analyzer",
    "taplo",
     "svelte",
    "tailwindcss",
})

vim.lsp.config("gdscript", {
  root_markers = { "project.godot", ".git" },
})

-- 2. Create an autocommand to enable it ONLY when a GDScript file is opened
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gdscript",
  callback = function()
    print("GDScript LSP: Enabling...")
    vim.lsp.enable("gdscript")
  end,
})

vim.filetype.add({
  extension = {
    gd = "gdscript",
    tres = "gdscript_resource",
    tscn = "gdscript_resource",
  },
})

-- 3. Debugging: This prints when the LSP actually attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "gdscript" then
      print("GDScript LSP attached to: " .. vim.api.nvim_buf_get_name(0))
    end
  end,
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



     -- Modern Rust LSP (rust-analyzer) with comprehensive type/inlay hints & clippy
    vim.lsp.config("rust_analyzer", {
        cmd = { "rust-analyzer" },
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true,
                },
                inlayHints = {
                    bindingModeHints = { enable = false },
                    chainingHints = { enable = true },
                    closingBraceHints = { enable = true, minLines = 25 },
                    closureReturnTypeHints = { enable = "never" },
                    lifetimeElisionHints = { enable = "never", useParameterNames = false },
                    matchesStorageClassHints = { enable = true },
                    parameterHints = { enable = true },
                    reborrowHints = { enable = "never" },
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
            },
        },
    })

    -- Cargo.toml / TOML LSP (taplo)
    vim.lsp.config("taplo", {
        cmd = { "taplo", "lsp", "stdio" },
        on_attach = on_attach,
    })

  vim.lsp.config("svelte", {
        on_attach = on_attach,
    })


   vim.lsp.config("tailwindcss", {
        on_attach = on_attach,
        filetypes = { "html", "css", "scss", "javascript", "typescript", "svelte", "vue" },
        root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git" },
    })

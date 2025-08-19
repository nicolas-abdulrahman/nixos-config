-- require("java").setup()

print("lspconfig loading")
vim.g.mapleader = " "
--local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

--require("nvim-autopairs").setup()
function on_attach(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.api.nvim_set_keymap("n", "<leader>cjr", "JavaRunnerRunMain", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader>cjb", "JavaBuildBuildWorkspace", { noremap = true })
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>ls", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<C-d>", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "<leader>ld", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>lsa", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>lsr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>li", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<leader>lt", function()
		vim.lsp.buf.type_definition()
	end, opts)
	vim.keymap.set("n", "<leader>lr", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<C-Space>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "<S-Space>", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>gt", function()
		vim.lsp.buf.type_definition()
	end, opts)
	vim.keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", opts)
	vim.keymap.set("n", "<leader>cf", function()
		vim.lsp.buf.format()
	end, opts)
	vim.keymap.set("n", "<S-h>", "<cmd>CommentToggle<CR>", opts)
	vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
	-- vim.keymap.set("n", "<leader>h", require("lsp_lines").toggle, opts)
end

-- vim.keymap.set("n", "<leader>h", require("lsp_lines").toggle, opts)

require("lspconfig").clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "clangd", "-I/usr/include/qt", "-I/usr/include/qt/QtCore", "-I/usr/include/qt/QtWidgets" },
})
require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "pyright-langserver", "--stdio" },
})

-- require("rust-tools").setup({
-- cmd = {"rustup", "run", "stable", "rust_analyzer"}
-- on_attach= lsp.on_attach
-- })
-- require('rust-tools').inlay_hints.enable()
--lsp.setup_servers({"rust_analyzer"})
-- require("lspconfig").rust_analyzer.setup{
-- cmd = {"rustup", "run", "stable", "rust_analyzer"},
-- root_dir = require('lspconfig.util').root_pattern({'.git'})

-- }
--
-- require("lspconfig").rust_analyzer.setup{}
-- require("lspconfig").asm_lsp.setup{
--     cmd={"rustup", "run", "stable", "asm-lsp"},
--     filetypes= { "asm", "vmasm", "s", "S"}
-- }
-- lsp.skip_server_setup({'rust_analyzer'})
-- require("lspconfig").rust_analyzer.setup({
-- cmd = {"/run/current-system/sw/bin/rust-analyzer"}
-- }
-- )
-- require("lspconfig").angularls.setup({
-- root_dir = require('lspconfig.util').root_pattern({'.git'})

-- })
-- require("lspconfig").antlersls.setup({
-- root_dir = require('lspconfig.util').root_pattern({'.git'})
-- })
--
-- require("lspconfig").html.setup({})
require("lspconfig").tsserver.setup({
	cmd = { "typescript-language-server", "--stdio" },
	-- cmd = { "nix", "run", "nixpkgs#typescript-language-server", "--", "--stdio" },
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = require("lspconfig.util").root_pattern({ ".git" }),
})
-- lldb_exec = concat_if_exist(os.getenv("LLDB"), "/bin/lldb-vscode")
require("lspconfig").lua_ls.setup({
	cmd = { "/run/current-system/sw/bin/lua-lsp" },
	on_attach = on_attach,
})
require("lspconfig").nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	on_attach = on_attach,
})
-- require("lspconfig").tsserver.setup({
-- cmd = { "typescript-language-server", "--stdio"},
-- on_attach = on_attach,
-- capabilities = capabilities
-- })
require("lspconfig").clangd.setup({
	cmd = { "/run/current-system/sw/bin/clangd" },
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

function concat_if_exist(path, path2)
	if path == nil then
		return
	else
		return path .. path2
	end
end
local rust_tools = require("rust-tools")

lldb_exec = concat_if_exist(os.getenv("LLDB"), "/bin/lldb-vscode")
lldb_lib = concat_if_exist(os.getenv("LLDB_LIB"), "/lib")
require("lspconfig").gopls.setup({
	cmd = { os.getenv("GOPLS_PATH") },
})
rust_tools.setup({
	server = {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			require("crates").setup()
			-- vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
		end,
		cmd = { "rust-analyzer" },

		root_dir = require("lspconfig.util").root_pattern({ ".git" }),
		capabilities = capabilities,
	},

	dap = {
		adapter = {
			type = "executable",
			command = "gdb",
			name = "rt_gdb",
		},
	},
})

-- local cap = vim.lsp.protocol.make_client_capabilities()
-- cap.textDocument.completion.completionItem.snippetSupport = true
-- require("lspconfig").html.setup({
-- capabilities = cap,
-- })
require("lspconfig").cssls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig").html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").css.setup({
	capabilities = capabilities,
})
require("lspconfig").cmake.setup({

	on_attach = on_attach,
})
require("lspconfig").jdtls.setup({
	cmd = { "jdtls" },
	on_attach = on_attach,
})

require("lspconfig").nil_ls.setup({})
require("lspconfig").sqls.setup({
	on_attach = function(client, bufnr)
		-- Disable all formatting capability of sqls
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
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

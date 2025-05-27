local cmp = require("cmp")
vim.g.mapleader = " "
cmp.setup({

	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			require("snippy").expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-m>"] = cmp.mapping.scroll_docs(-4),
		["<C-,>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		--  { name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		{ name = "snippy" }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})
--local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

--require("nvim-autopairs").setup()
function on_attach(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>cs", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<C-d>", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>csa", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>csr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>csi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<leader>cst", function()
		vim.lsp.buf.type_definition()
	end, opts)
	vim.keymap.set("n", "<leader>cr", function()
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
})
require("lspconfig").nixd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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

require("lspconfig").zls.setup({})

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
})
require("lspconfig").superhtml.setup({
	capabilities = capabilities,
})

require("lspconfig").cmake.setup({})
require("lspconfig").jdtls.setup({
	cmd = { "jdtls" },
})

require("lspconfig").nil_ls.setup({})

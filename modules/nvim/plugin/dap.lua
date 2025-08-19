local dap = require("dap")

local ui = require("dapui")
ui.setup()

vim.keymap.set("n", "<leader>du", function()
	ui.open()
end, opts)

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	name = "gdb",
	args = { "--interpreter=mi" }, -- this is essential

	-- args = { "-i=mi" },
}

dap.adapters.lldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "lldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.zig = {
	{
		name = "Launch Zig with GDB",
		type = "codelldb",
		request = "launch",
		program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
		-- program = function()
		-- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
		-- end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {}, -- pass args if your program needs
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

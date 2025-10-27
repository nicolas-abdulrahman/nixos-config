vim.keymap.set("n", "<leader>da", function()
	require("dap").toggle_breakpoint()
end, opts)
vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end, opts)
vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end, opts)
vim.keymap.set("n", "<leader>du", function()
	require("dapui").open()
end, opts)
vim.keymap.set("n", "<F1>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F2>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F3>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F4>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>da", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>db", function()
	require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>de", function()
	require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

require("dapui").setup()
vim.keymap.set("n", "<Leader>du", function()
	require("dapui").toggle()
end)

local dap = require("dap")

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap" },
	-- args = { "-i=mi" },
}

local c = {
	name = "Launch",
	type = "gdb",
	request = "launch",
	cwd = "${workspaceFolder}",
	program = "${workspaceFolder}/build/Main", -- Path to your executable
}
dap.configurations.c = {
	-- c,
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executableeeee: ", vim.fn.getcwd() .. "/", "file")
		end,
		-- pid = function()
		-- local name = vim.fn.input("Executable name (filter): ")
		-- return require("dap.utils").pick_process({ filter = name })
		-- end,
		cwd = "${workspaceFolder}",
		-- args = {},
	},
}
-- dap.configurations.cpp = { c }

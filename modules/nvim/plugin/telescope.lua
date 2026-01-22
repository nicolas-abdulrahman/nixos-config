local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").load_extension("fzf")
require("telescope").setup({
	defaults = {
		prompt_prefix = "الحمد لله",

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		file_previewer_title = "File Preview",
		mappings = {
			i = {
				["<M-n>"] = function(prompt_bufnr)
					actions.send_to_qflist(prompt_bufnr)
					actions.open_qflist()
				end,
			},
			n = {
				["<M-n>"] = function(prompt_bufnr)
					actions.send_to_qflist(prompt_bufnr)
					actions.open_qflist()
				end,
			},
		},
	},
})

local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "find file" })
vim.keymap.set("n", "<leader>tnf", function()
	builtin.find_files({ cwd = "/etc/nixos/modules/nvim" })
end, { desc = "Neovim" })
vim.keymap.set("n", "<leader>tg", builtin.git_files, { desc = "git_files" })
vim.keymap.set("n", "<leader>td", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>tb", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>ts", function()
	builtin.live_grep()
end, { desc = "live grep" })
vim.keymap.set("n", "<leader>tsb", function()
	local file = vim.fn.expand("%:p") -- full path of current file
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 40 },
		},
	})
	pickers
		.new({}, {
			prompt_title = "Grep Current File (cleaned)",
			finder = finders.new_oneshot_job({
				"rg",
				"--with-filename",
				"--line-number",
				"--column",
				".", -- match all
				file,
			}, {
				entry_maker = function(line)
					local path, lnum, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
					return {
						value = line,
						display = text, -- 👈 only show matched text
						ordinal = text, -- 👈 only match on the text
						lnum = tonumber(lnum),
						col = tonumber(col),
						filename = path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.grep_previewer({}),
			attach_mappings = function(_, map)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				map("i", "<CR>", function(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("edit " .. entry.filename)
					vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
				end)
				return true
			end,
		})
		:find()
end, { desc = "grep string" })

vim.keymap.set("n", "<leader>t.s", function()
	builtin.grep_string({})
end, { desc = "grep string" })
vim.keymap.set("n", "<leader>t.m", function()
	require("telescope.builtin").lsp_document_symbols({
		symbols = { "Function", "Method" },
		cwd = vim.fn.expand("%:p:h"),
	})
end, {})
vim.keymap.set("n", "<leader>tmc", function()
	require("telescope.builtin").lsp_document_symbols({ symbols = { "Function", "Method" } })
end, {})

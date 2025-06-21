local builtin = require("telescope.builtin")

require("telescope").load_extension("fzf")
require("telescope").setup({

	defaults = {
		prompt_prefix = "$ ",
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		file_previewer_title = "File Preview",
	},
})
vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "find file" })
vim.keymap.set("n", "<leader>tg", builtin.git_files, { desc = "git_files" })
vim.keymap.set("n", "<leader>td", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>tb", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>tn", function()
	builtin.find_files({ cwd = "/etc/nixos/users/sunshine/modules/nvim/" })
end, { desc = "Neovim" })
vim.keymap.set("n", "<leader>tl", function()
	builtin.live_grep()
end, { desc = "live grep" })
vim.keymap.set("n", "<leader>ts", function()
	builtin.grep_string({})
end, { desc = "grep string" })

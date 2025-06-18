require("tabbys").setup({ keymaps = { leader = "" } })

vim.keymap.set("n", "ts", function()
	require("tabbys").setup_tab()
end, {
	desc = "Tabby: new",
})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").load_extension("fzf")

require("telescope").setup({
  defaults = {
    prompt_prefix = "Allahu akbar! ",
    mappings = {
      i = {
        ["<M-n>"] = function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
          actions.open_qflist()
        end,
        ["<C-n>"] = function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
        end,
      },
      n = {
        ["<M-n>"] = function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
          actions.open_qflist()
        end,
        ["<C-n>"] = function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
        end,
      },
    },
  },
})

local prefix = "<leader><leader>"

local function map_telescope(key, cmd, name, args)

  vim.keymap.set("n", prefix .. key, function()
    local git_files = vim.fn.systemlist("git ls-files")
    if vim.v.shell_error ~= 0 then
      vim.notify("Not in a git repository!", vim.log.levels.WARN)
      local title = name .. " (CWD)"
      cmd(vim.tbl_deep_extend("force", { prompt_title = title }, args or {}))
    end
    local title = name .. " (Git Files)"
    local base_opts = { search_dirs = git_files, prompt_title = title }
    local final_opts = vim.tbl_deep_extend("force", base_opts, args or {})
    cmd(final_opts)
  end, { desc = title})

  vim.keymap.set("n", prefix .. string.upper(key), function()
    local title = name .. " (Current Dir)"
    local base_opts = { cwd = vim.fn.expand("%:p:h"), prompt_title = title }
    local final_opts = vim.tbl_deep_extend("force", base_opts, args or {})
    cmd(final_opts)
  end, { desc =title })

  vim.keymap.set("n", prefix .. "<A-" .. key .. ">", function()
    local title = name .. " (Current Buffer)"
    local base_opts = { prompt_title = name .. " (Current Buffer)" }
    local final_opts = vim.tbl_deep_extend("force", base_opts, args or {})
    cmd(final_opts)
  end, { desc = title})

  vim.keymap.set("n", prefix .. "<C-" .. key .. ">", function()
    local title = name .. " (CWD)"
    local base_opts = { prompt_title = title }
    local final_opts = vim.tbl_deep_extend("force", base_opts, args or {})
    cmd(final_opts)
  end, { desc = title })
end

map_telescope("g", builtin.live_grep, "Live Grep")
vim.keymap.set("n", prefix .. "<A-g>", builtin.current_buffer_fuzzy_find, {})
map_telescope("f", builtin.find_files, "Find File")
map_telescope("s", builtin.grep_string, "Grep String")
map_telescope("m", builtin.lsp_document_symbols, "Grep String", {symbols = {"Function", "Method"}})


vim.keymap.set("n", prefix .. "n", function()
  builtin.find_files({ cwd = "/etc/nixos/modules/nvim" })
end, { desc = "Neovim config" })
vim.keymap.set("n", prefix .. "d", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", prefix .. "b", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", prefix .. "m", function()
  builtin.lsp_document_symbols({ symbols = { "Function", "Method" }, cwd = vim.fn.expand("%:p:h") })
end, { desc = "LSP symbols (current dir)" })
vim.keymap.set("n", prefix .. "M", function()
  builtin.lsp_document_symbols({ symbols = { "Function", "Method" } })
end, { desc = "LSP symbols (all)" })

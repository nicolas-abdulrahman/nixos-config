-- =========================================================================
-- CodeCompanion Configuration
-- =========================================================================
require("codecompanion").setup({
  adapters = {
    http = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "GEMINI_API_KEY_NASR",
          },
          schema = {
            model = {
              default = "gemini-3.1-flash-lite",
            },
          },
        })
      end,
    },
  },

  interactions = {
    chat = {
      adapter = "gemini",
      editor_context = {
        ["a"] = {
          description = "Custom Agent Context",
          callback = "require('my_custom_contexts').agent_context", 
          opts = { contains_code = true },
        },
        ["c"] = {
          description = "Command Mode Context",
          callback = "require('my_custom_contexts').command_context", 
        },
      },
    },
    
    -- THIS IS WHERE THE DIFF WORKFLOW HAPPENS
    inline = { 
      adapter = "gemini",
      -- Natively define the Accept/Reject keys for the Diff view
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "Accept the suggested AI change",
        },
        reject_change = {
          modes = { n = "gr" },
          description = "Reject the suggested AI change",
        },
      },
    },
    cmd = { adapter = "gemini" },

    cli = {
      agent = "gemini_cli",
      agents = {
        gemini_cli = {
          cmd = "gemini",  
          args = {},
          description = "Gemini CLI Integration",
          provider = "terminal",
        },
      },
    },
  },

  -- Ensure CodeCompanion uses the standard Neovim Diff view
  display = {
    diff = {
      provider = "default",
    },
  },
})

-- =========================================================================
-- Insert-Mode Aliases (Only active in CodeCompanion buffers)
-- =========================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "codecompanion",
  callback = function()
    vim.cmd("iabbrev <buffer> #b #{buffer}")
    vim.cmd("iabbrev <buffer> #d #{cwd}")
    vim.cmd("iabbrev <buffer> @a @{agent}")
    vim.cmd("iabbrev <buffer> @c @{cmd}")
  end,
})

-- =========================================================================
-- Quick Shortcuts
-- =========================================================================
local keymap = vim.keymap.set

-- <leader>ab triggers the INLINE Diff mode (What you want to use for editing files!)
keymap({"n", "v"}, "<leader>ab", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion Inline (Diff Mode)" })

-- <leader>ac triggers the Chat Sidebar (For conversations)
keymap({"n", "v"}, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion Chat Toggle" })

keymap("v", "<leader>al", "<cmd>CodeCompanionChat Add<cr>", { desc = "CodeCompanion Add to Chat" })
keymap({"n", "v"}, "<leader>ar", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })


-- When you have an AI code block in your chat, use this to force the split
vim.keymap.set("n", "<leader>ad", function()
    -- This looks for a CodeCompanion buffer and tries to trigger the diff
    local ok, cc = pcall(require, "codecompanion")
    if ok then
        -- This is the internal API call to start the diff process
        require("codecompanion.strategies.inline"):new({
            context = require("codecompanion.helpers.actions").get_context(0),
            prompt = "Apply the last code block from the chat"
        }):start()
    end
end, { desc = "Force AI Diff View" })
-- Optional: Improve diff algorithm for cleaner AI code comparison
vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("indent-heuristic")

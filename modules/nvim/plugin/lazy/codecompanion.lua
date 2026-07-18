-- ~/.config/nvim/lua/plugins/codecompanion.lua
local codecompanion = require("codecompanion")



codecompanion.setup({
  -- Set the default adapter for chat and inline interactions
  strategies = {
    chat = { adapter = "gemini" },
    inline = { adapter = "gemini" },
  },

  -- Configure the Gemini HTTP adapter
  adapters = {
    http = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = vim.env.GEMINI_API_KEY,   -- Ensure this env var is set
          },
          schema = {
            model = {
              default = "gemini-3.5-flash",     -- 👈 The model goes here
            },
          },
        })
      end,
    },
  },

  -- Your custom prompt library (slash commands)
  prompt_library = {
    ["Rust Expert"] = {
      strategy = "chat",
      description = "Chat with a low-level Systems and Rust programming wizard.",
      opts = {
        index = 1,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = "You are an elite systems engineer and Rust core developer. Write extremely idiomatic, memory-safe, zero-cost abstraction code. Focus on performance, explicit error handling, and strict ownership rules.",
        },
      },
    },
    ["NixOS Expert"] = {
      strategy = "chat",
      description = "Debug declarative builds and Nix expressions.",
      opts = {
        index = 2,
        is_slash_cmd = true,
      },
      prompts = {
        {
          role = "system",
          content = "You are a NixOS and Flakes veteran. Assist with fixing store collisions, writing clean modular home-manager modules, and designing strict, reproducible derivations.",
        },
      },
    },
  },
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "@@", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

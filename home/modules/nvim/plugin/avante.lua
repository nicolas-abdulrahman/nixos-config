-- plugin/avante.lua
require("avante_lib").load()

require("avante").setup({
  provider = "gemini",
  mode = "default", -- explicit, though it's already the default
 templates = {
    default = "",   -- suppress the missing file error
  },

  providers = {
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-3.1-flash-lite",
      timeout = 30000,
      context_window = 1048576,

      api_key_name = "GEMINI_API_KEY_NASR",
      use_ReAct_prompt = true,

      extra_request_body = {
        generationConfig = {
          temperature = 0,
        },
      },
      -- no disable_tools — agentic mode needs tool calls to write/apply edits
    },
  },

  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = true,
    support_paste_from_clipboard = true,
  },
})

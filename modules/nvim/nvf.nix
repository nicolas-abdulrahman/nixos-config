{ pkgs, ... }:
let
  tab-pin = pkgs.vimUtils.buildVimPlugin {
    name = "tab-pin";
    src = ./my-plugins/tab-pin;
  };
in
{
  config.vim = {
    # Core settings
    visuals.nvim-web-devicons.enable = true;
    theme = { enable = true; name = "catppuccin"; style = "mocha"; };

    languages = {
      lua.enable = true;
      enableDAP = true;
    };

    ui.noice.enable = true; # Highly recommended for Avante's UI

    # We need to configure dressing to play nice with Avante
    visuals.fidget-nvim.enable = true; # Useful for seeing AI progress

    # DAP Configuration
    debugger.nvim-dap = {
      enable = true;
      mappings = {
        restart = "<leader>dr"; terminate = "<leader>dq"; runLast = "<leader>dl";
        toggleRepl = "<leader>dtr"; hover = "<leader>dh"; toggleBreakpoint = "<leader>db";
        runToCursor = "<leader>dgc"; continue = "<F1>"; stepOver = "<F2>";
        stepInto = "<F3>"; stepOut = "<F4>"; stepBack = "<leader>dgb";
        goUp = "<leader>dgu"; goDown = "<leader>dgd"; toggleDapUI = "<leader>du";
      };
    };

    assistant.avante-nvim = {
      enable = true;
      setupOpts = {
        mode = "manual";
        provider = "gemini";
        auto_suggestions_provider = "gemini";

        providers = {
          gemini = {
            model = "gemini-3.5-flash-lite";
            api_key_name = "GEMINI_API_KEY_NASR";
          };
        };

        selector = {
          provider = "telescope";
        };
      };
    };

    # Plugin Management
    lazy.plugins = import ./lazy.nix { inherit pkgs; };
    extraPlugins = with pkgs.vimPlugins; {
      promise-async = {
        package = promise-async;
      };
      statuscol = {
        package = statuscol-nvim;
      };
      nvim-ufo = {
        package = pkgs.vimPlugins.nvim-ufo;
        after = [ "promise-async" "statuscol" ];
        setup = builtins.readFile ./plugin/ufo.lua;
      };
      comment-nvim = {
        package = pkgs.vimPlugins.comment-nvim;
        setup = ''
          require("Comment").setup({
            toggler = {
              line = "<C-h>",  -- Normal mode toggle line comment
              block = "<C-h>", -- Normal mode toggle block comment
            },
            opleader = {
              line = "<C-h>",  -- Visual/Operator-pending line comment
              block = "<C-h>", -- Visual/Operator-pending block comment
            },
          })
        '';
      };
      aider-nvim = {
        package = aider-nvim;
        setup = ''
          require("aider").setup({
            backend = "gemini",
            model = "gemini-3.1-flash-lite",
            auto_manage = false,
          })

          vim.keymap.set("n", "<leader>aa", ":AiderToggle<CR>", { desc = "Toggle Aider" })
          vim.keymap.set("n", "<leader>af", ":AiderAddFile<CR>", { desc = "Aider: Add file" })
          vim.keymap.set("v", "<leader>as", ":AiderSend<CR>", { desc = "Aider: Send selection" })
        '';
      };

      codecompanion = {
        package = pkgs.vimPlugins.codecompanion-nvim;
        after = [ "plenary" ];
        setup = builtins.readFile ./plugin/codecompanion.lua;
      };

      fzf = { package = telescope-fzf-native-nvim; };
      telescope = { package = telescope-nvim; after = [ "fzf" ]; setup = builtins.readFile ./plugin/telescope.lua; };
      notify = { package = nvim-notify; };

      conform = { package = conform-nvim; setup = builtins.readFile ./plugin/conform.lua; };
      tab-pin = {
        package = tab-pin;
        setup = ''
          local tab_pin = require("tab-pin")
          tab_pin.setup({})
        '';
      };

      cmp = { package = nvim-cmp; };
      cmp-nvim-lsp = { package = cmp-nvim-lsp; };
      lspconfig = {
        package = nvim-lspconfig;
        after = [ "cmp" "cmp-nvim-lsp" ];
        setup = builtins.readFile ./plugin/lsp.lua;
      };

      indent-blankline = {
        package = indent-blankline-nvim;
        setup = "require('ibl').setup({ indent = { char = '┊' }, scope = { enabled = false } })";
      };

      dressing = {
        package = dressing-nvim;
        setup = "require('dressing').setup({})";
      };
      mini = {
        package = pkgs.vimPlugins.mini-nvim;
        setup = "require('mini.ai').setup()";
      };
      hlslens = {
        package = pkgs.vimPlugins.nvim-hlslens;
        setup = builtins.readFile ./plugin/hlslens.lua;
      };
      lualine = {
        package = pkgs.vimPlugins.lualine-nvim;
        after = [ "gitsigns" ];
        setup = builtins.readFile ./plugin/lualine.lua;
      };

      gitsigns = {
        package = pkgs.vimPlugins.gitsigns-nvim;
        setup = "require('gitsigns').setup()";
      };

      plenary = {
        package = plenary-nvim;
      };

      copilot-lua = {
        package = copilot-lua;
        setup = ''
          require("copilot").setup({
            panel = {
              enabled = false,
            },
            suggestion = {
              enabled = true,
              auto_trigger = true,
              debounce = 500,
              keymap = {
                accept = "<right>",
                next = "<M-Tab>",
                prev = "<M-down>
                dismiss = "<left>",
              },
            },
          })
        '';
      };

      blink-cmp = {
        package = pkgs.vimPlugins.blink-cmp;
        setup = ''
          require("blink.cmp").setup({
            sources = {
              default = { "lsp", "path", "buffer", "snippets" },
            },
            completion = {
              ghost_text = {
                enabled = false,
              },
              documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
              },
            },
            keymap = {
              preset = 'none',
              ["<S-Up>"] = { 'scroll_documentation_up', 'fallback' },
              ["<S-Down>"] = { 'scroll_documentation_down', 'fallback' },
              ["<S-Space>"] = { 'show', 'show_documentation', 'hide_documentation' },
              ["<Left>"] = { 'cancel' },
              ["<Tab>"] = { 'select_and_accept', 'fallback' },
              ["<Up>"] = { 'select_prev', 'fallback' },
              ["<Down>"] = { 'select_next', 'fallback' },
            },
          })
        '';
      };
    };

    luaConfigRC = {
      remap = builtins.readFile ./lua/remap.lua;
      set = builtins.readFile ./lua/set.lua;
      lsp = builtins.readFile ./lua/lsp.lua;
      autocmds = builtins.readFile ./lua/autocmds.lua;
      lsp2 = ''
        vim.keymap.set('n', '<leader>ll', function()
          ${builtins.readFile ./plugin/lsp.lua}
          print("LSP2 configuration loaded!")
        end, { desc = "Load LSP2 configurations", silent = true })
      '';
      macros = builtins.readFile ./lua/quick_macros.lua;
    };

    languages.markdown.extensions.render-markdown-nvim.enable = true;

    startPlugins = with pkgs.vimPlugins; [
      telescope-nvim img-clip-nvim render-markdown-nvim
    ];

    extraPackages = with pkgs; [
      gemini-cli llm-ls nodejs ripgrep fd aider-chat godot_4
      lua-language-server
      gopls pyright clang-tools zls sqls typescript-language-server nixd
      stylua prettierd rust-analyzer
    ];

    visuals.indent-blankline = {
      enable = true;
      setupOpts = {
        indent = {
          char = "┊";
        };
        scope = {
          enabled = true;
          char = "┋";
        };
      };
    };

    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        lua
        nix
        python
        gdscript
        rust
        godot_resource
      ];
    };
  };
}

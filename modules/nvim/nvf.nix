{ pkgs,  ... }:
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
                model = "gemini-3.1-flash-lite"; 
                api_key_name = "GEMINI_API_KEY_NASR";
              };
            };

            # --- THE FIX ---
            # This tells Avante to completely bypass vim.ui.select (which dressing 
            # has infected) and route all of its menus through Telescope instead.
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
      #avante = {
      #  package = pkgs.vimPlugins.avante-nvim;
      #   setup = builtins.readFile ./plugin/avante.lua;
      # };
      aider-nvim = {
        package = aider-nvim;
        setup = ''
          require("aider").setup({
            -- Use Gemini as the backend
            backend = "gemini",
            -- Model name (choose any Gemini variant you like)
            model = "gemini-3.1-flash-lite",   
            -- Optional: auto-open on file open? (default is false)
            auto_manage = false,
            -- If aider binary is not in PATH, specify full path:
            -- aider_cmd = "${pkgs.aider-chat}/bin/aider",
          })

          vim.keymap.set("n", "<leader>aa", ":AiderToggle<CR>", { desc = "Toggle Aider" })
        vim.keymap.set("n", "<leader>af", ":AiderAddFile<CR>", { desc = "Aider: Add file" })
        vim.keymap.set("v", "<leader>as", ":AiderSend<CR>", { desc = "Aider: Send selection"})
        '';
      };



      codecompanion = {
        package = pkgs.vimPlugins.codecompanion-nvim;
        # Ensure dependencies like plenary and treesitter are available
        after = ["plenary"]; 
        setup = builtins.readFile ./plugin/codecompanion.lua;
      };

      fzf = { package = telescope-fzf-native-nvim; };
      telescope = { package = telescope-nvim; after = [ "fzf" ]; setup = builtins.readFile ./plugin/telescope.lua; };
      notify = { package = nvim-notify; };


      conform = { package = conform-nvim; setup = builtins.readFile ./plugin/conform.lua; };
     tab-pin = {package =tab-pin;
        setup = ''
          local tab_pin = require("tab-pin")
          tab_pin.setup({})
        '';
      };

      cmp = { package = nvim-cmp; };
      cmp-nvim-lsp = { package = cmp-nvim-lsp; };
      lspconfig = { package = nvim-lspconfig;
        after = ["cmp" "cmp-nvim-lsp"];
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
        after = ["gitsigns"];
        setup = builtins.readFile ./plugin/lualine.lua;
      };

      gitsigns = {
        package = pkgs.vimPlugins.gitsigns-nvim;
        setup = "require('gitsigns').setup()";
      };

      plenary = {
        package = plenary-nvim;
      };
      minuet = {
        package = pkgs.vimPlugins.minuet-ai-nvim;
        after = ["plenary"];
        setup = ''
          require("minuet").setup({
            provider = "gemini",
            provider_options = {
              gemini = {
                model = "gemini-3.1-flash-lite",
              },
            },
            virtualtext = {
            auto_trigger_ft = { 
  "python", "lua", "rust", "cpp", "javascript", "typescript", "nix", 
  "go", "html", "css", "json", "yaml", "markdown", "bash", "sh", "gd", "tres", "gdscript"
},
              show_on_completion_menu = true, -- Forces Minuet to show over blink.cmp
              keymap = {
                accept = "<A-Tab>",    -- Alt+Tab: Accept full completion
                accept_line = "<Tab>",  -- Tab: Accept one line
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
                enabled = false, -- Disabled to prevent overlap with Minuet
              },
            },
            keymap = {
              preset = 'none',
              ["<A-Up>"] = { 'scroll_documentation_up', 'fallback' },
              ["<A-Down>"] = { 'scroll_documentation_down', 'fallback' },
              ["<A-Space>"] = { 'show', 'show_documentation', 'hide_documentation' },
              ["<Left>"] = { 'cancel' },
              ["<Right>"] = { 'select_and_accept', 'fallback' },
              ["<Up>"] = { 'select_prev', 'fallback' },
              ["<Down>"] = { 'select_next', 'fallback' },
            },
            completion = {
              documentation = { 
                auto_show = true, 
                auto_show_delay_ms = 200 
              },
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
          -- This executes the contents of your lsp.lua file only when pressed
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
      gemini-cli llm-ls nodejs ripgrep fd  aider-chat godot_4
      lua-language-server # lua_ls
      gopls pyright clang-tools zls sqls typescript-language-server nixd ripgrep
      stylua prettierd rust-analyzer

    ];

    visuals.indent-blankline = {
      enable = true;
      setupOpts = {
        indent = {
          char = "┊"; # You can use "┋", "┆", "┊", or "." depending on your preference
        };
        scope = {
        enabled = true;
        char = "┋"; # The solid line chunk highlighting your current active block scope
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
        godot_resource # Adds syntax highlighting for .tres and .tscn files
      ];
    };
  };
}

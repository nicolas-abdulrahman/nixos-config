{ pkgs, ... }:
let
  flakePath= "/etc/nixos";
  tab-pin = pkgs.vimUtils.buildVimPlugin {
    name = "tab-pin";
    src = ./my-plugins/tab-pin;
  };
in
{
  config.vim = {
    visuals.nvim-web-devicons.enable = true;
    theme = { enable = true; name = "catppuccin"; style = "mocha"; };

    clipboard = {
      enable = true;
      registers = "unnamedplus"; 

      providers = {
        wl-copy.enable = true; # For Wayland (Hyprland / WSLg)
        xclip.enable = true;   # For X11 / Xserver
      };
    };

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
        focus = {
            package = focus-nvim;
            setup = ''
              require("focus").setup({
                autoresize = {
    		  enable = true,
    		  width = 0,  -- 0 activates golden ratio (~65-70% width for the active buffer)
    		  height = 0, -- golden ratio for vertical splits (or set equalise = true)
    		  minwidth = 25,
                },
                ui = {
    		  signcolumn = false, -- keeps your existing statuscol/signs intact
                },
              })

               vim.keymap.set("n", "<leader>.", "<cmd>FocusSplitNicely<CR>", { desc = "Focus Split Nicely" })
               vim.keymap.set("n", "<leader>,", "<cmd>FocusToggle<CR>",      { desc = "Toggle Focus Auto-resize" })

            '';

          };

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


      fzf = { package = telescope-fzf-native-nvim; };
      telescope = { package = telescope-nvim; after = [ "fzf" ]; setup = builtins.readFile ./plugin/telescope.lua; };
      notify = { package = nvim-notify; };

      conform = { package = conform-nvim; setup = builtins.readFile ./plugin/conform.lua; };
      tab-pin = {
        package = tab-pin;
        setup = ''
          local tab_pin = require("tab-pin")
          tab_pin.setup({})

          local map = vim.keymap.set
          local opts = { silent = true }

          -- Tab Navigation & Lifecycle (Default Vim commands)
          map("n", "<M-h>", "<cmd>tabprevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous tab" }))
          map("n", "<M-l>", "<cmd>tabnext<CR>",     vim.tbl_extend("force", opts, { desc = "Next tab" }))
          map("n", "<M-q>", "<cmd>tabclose<CR>",    vim.tbl_extend("force", opts, { desc = "Close tab" }))
          map("n", "<M-n>", "<cmd>tabnew<CR>",      { silent = true, desc = "New tab" })

          -- TabPin Operations
          map("n", "<M-p>", "<cmd>TabPinToggle<CR>", vim.tbl_extend("force", opts, { desc = "TabPin: Toggle pin" }))
          map("n", "<M-s>", "<cmd>TabPinSave<CR>",   vim.tbl_extend("force", opts, { desc = "TabPin: Save pins" }))

          -- Collision note: Changed Alt+l (Load) to Alt+o to keep Alt+l for Next Tab
          map("n", "<M-o>", "<cmd>TabPinLoad<CR>",   vim.tbl_extend("force", opts, { desc = "TabPin: Load pins" }))
          map("n", "<M-n>", "<cmd>tabnew<CR>",      { silent = true, desc = "New tab" })
        '';
      };

      cmp = { package = nvim-cmp; };
      cmp-nvim-lsp = { package = cmp-nvim-lsp; };
      crates = {
        package = crates-nvim;
      };
      lspconfig = {
        package = nvim-lspconfig;
        after = [ "crates" ];
        setup = builtins.readFile ./plugin/lsp.lua + ''
          local hostname = vim.uv.os_gethostname()
          local flake_path = "${flakePath}"

          vim.lsp.config("nixd", {
            cmd = { "nixd" },
            filetypes = { "nix" },
            root_markers = { "flake.nix", ".git" },
            settings = {
              nixd = {
                nixpkgs = {
                  expr = "import <nixpkgs> { }",
                },
                options = {
                  nixos = {
                    expr = string.format('(builtins.getFlake "%s").nixosConfigurations.%s.options', flake_path, hostname),
                  },
                  home_manager = {
                    expr = string.format(
                      '(builtins.getFlake "%s").nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []',
                      flake_path,
                      hostname
                    ),
                  },
                },
              },
            },
          })
          '';
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


      blink-cmp = {
        package = pkgs.vimPlugins.blink-cmp;
         setup = ''
              require("blink.cmp").setup({
                sources = {
                  default = { "lsp", "path" },
                },
                completion = {
                  ghost_text = {
                    enabled = false,
                  },
                  menu = {
                    draw = {
                      -- Shows: [Icon] [Name + LSP detail/signature] [Kind]
                      columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "kind" },
                      },
                    },
                  },
                  documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    window = {
                      border = "rounded",
                    },
                  },
                }, -- <-- This was missing
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
      wl-clipboard  # Hyprland / Wayland clipboard tool
      xclip         # X11 / Xserver clipboard tool
      antigravity-cli llm-ls nodejs ripgrep fd godot_4
      lua-language-server
      gopls pyright clang-tools zls sqls typescript-language-server nixd
      stylua prettierd rust-analyzer taplo
       vscode-langservers-extracted  # <-- VS Code CSS (and HTML/JSON/ESLint) LSP
          svelte-language-server
        tailwindcss-language-server
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
            svelte
            html
            css
            javascript
            typescript
          ];
    };
  };
}

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

    # Plugin Management
    lazy.plugins = {
      "aerial.nvim" = {
        package = pkgs.vimPlugins.aerial-nvim;
        setupModule = "aerial";
        setupOpts = { backends = [ "lsp"  "markdown" ]; }; # Fixed the 'no symbols' issue
        cmd = [ "AerialOpen" ];
        event = [ "BufEnter" ];
        keys = [
          { mode = "n"; key = "<leader>x"; action = ":AerialToggle<CR>"; }
          { mode = "n"; key = "<C-A-j>"; action = ":AerialNext<CR>"; }
          { mode = "n"; key = "<C-A-k>"; action = ":AerialPrev<CR>"; }
        ];
      };
      "neo-tree.nvim" = {
    package = pkgs.vimPlugins.neo-tree-nvim;
    setupModule = "neo-tree";
    
    # 1. Triggers that wake the plugin up
    cmd = [ "Neotree" ];
    keys = [
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; }
    ];

    # 2. Setup options converted directly to the lazy format
    setupOpts = {
      filesystem = {
        follow_current_file = {
          enabled = true;
        };
      };
    };
  };
    };

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
      lspconfig = { package = nvim-lspconfig; };
      codecompanion = { package = codecompanion-nvim; };
      nui = { package = nui-nvim; };
      dressing = { package = dressing-nvim; };

      indent-blankline = {
        package = indent-blankline-nvim;
        setup = "require('ibl').setup({ indent = { char = '┊' }, scope = { enabled = false } })";
      };
    };


    luaConfigRC = {
      remap = builtins.readFile ./lua/remap.lua;
      set = builtins.readFile ./lua/set.lua;
      lsp = builtins.readFile ./lua/lsp.lua;
      autocmds = builtins.readFile ./lua/autocmds.lua;
      postHighlight = ''
        vim.api.nvim_set_hl(0, "IblScope", { link = "Special" })
      '';
    lsp2 = ''
        vim.keymap.set('n', '<leader>ll', function()
          -- This executes the contents of your lsp.lua file only when pressed
          ${builtins.readFile ./plugin/lsp.lua}
          print("LSP2 configuration loaded!")
        end, { desc = "Load LSP2 configurations", silent = true })
      ''; 
    };

    startPlugins = with pkgs.vimPlugins; [
      telescope-nvim
    ];

    extraPackages = with pkgs; [
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

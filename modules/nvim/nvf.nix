{ pkgs, ... }:
let
  tabbys-package = pkgs.vimUtils.buildVimPlugin {
    name = "tabbys-nvim";
    src = ./my-plugins/tabbys;
  };
  tab-pin = pkgs.vimUtils.buildVimPlugin {
    name = "tab-pin";
    src = ./my-plugins/tab-pin;
  };

in
{
  config.vim = {
    visuals.nvim-web-devicons.enable = true;
    debugger.nvim-dap = {
      enable = true;
      mappings = {
        restart = "<leader>dr";
        terminate = "<leader>dq";
        runLast = "<leader>dl";
        toggleRepl = "<leader>dtr";
        hover = "<leader>dh";
        toggleBreakpoint = "<leader>db";
        runToCursor = "<leader>dgc";
        continue = "<F1>";
        stepOver = "<F2>";
        stepInto = "<F3>";
        stepOut = "<F4>";
        stepBack = "<leader>dgb";
        goUp = "<leader>dgu";
        goDown = "<leader>dgd";
        toggleDapUI = "<leader>du";
      };
    };
    # visuals.nvim-web-devicons.enable = true;
    telescope.enable = false;
    # telescope = {
    #   enable = true;
    #   extensions = [{
    #     name = "fzf";
    #     packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
    #     setup = { fzf = { fuzzy = true; }; };
    #   }];
    # };
    # treesitter.enable = true;
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };
    lazy.plugins = {
      "aerial.nvim" = {
        # ^^^^^^^^^ this name should match the package.pname or package.name
        package = pkgs.vimPlugins.aerial-nvim;
        setupModule = "aerial";
        setupOpts = { option_name = false; };
        after = "print('aerial loaded')";
        cmd = [ "AerialOpen" ];
        # load on event
        event = [ "BufEnter" ];
        # load on keymap
        keys = [
          {
            mode = "n";
            key = "<leader>x";
            action = ":AerialToggle<CR>";
          }
        ];
      };
    };
    languages =
      {
        # r#ust = {
        #    enable = true;
        #   keymaps = "";
        #   };
        # rust.enable = true;
        # nix.enable = true;
        # sql.enable = true;
        # clang.enable = true;
        # ts.enable = true;
        # python.enable = true;
        # zig.enable = true;
        # go.enable = true;
        lua.enable = true;
        enableDAP = true;
      };
    startPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      telescope-nvim
    ];

    # conform =
    #   {
    #    lua = [
    #     "stylua"
    #  ];
    # python = [
    #   "isort"
    #   "black"
    # ];
    #rust = [
    # "rustfmt"
    #];
    #javascript = [ "prettierd" "prettier" ];
    #html = [ "htmlbeautifier" "superhtml" "js-beautify" "tidy" "prettierd" ];
    #css = [ "js-beautify" "tidy" "prettierd" ];
    #nix = [ "nixpkgs_fmt" ];
    #typescript = [ "prettier" ];
    #javascriptreact = [ "prettierd" ];
    #typescriptreact = [ "prettierd" ];
    #json = [ "prettierd" ];
    # html = [ "prettierd" ];
    # css = [ "prettierd" ];
    #markdown = [ "prettierd" ];
    #};
    extraPlugins = with pkgs.vimPlugins;
      {
        #     packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
        fzf = {
          package = telescope-fzf-native-nvim;
        };
        telescope = {
          package = telescope-nvim;
          after = [ "fzf" ];
          setup = pkgs.lib.readFile ./plugin/telescope.lua;
        };

        notify = {
          package = nvim-notify;
        };
        tabbys = {
          package = tabbys-package;
          setup = ''
            require('tabbys').setup()
            vim.keymap.set("n", "ts", function()
            	require("tabbys").setup_tab()
            end, {
            	desc = "Tabby: new",
            })
          '';
        };
        icons = {
          package = nvim-web-devicons;
        };
        neo_tree = {
          package = neo-tree-nvim;
          setup = ''
            -- require('neo-tree').setup()
            --      require("nvim-web-devicons")
                  vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
          '';
          after = [ "icons" ];
        };
        tmux_navigator = {
          package = pkgs.vimPlugins.vim-tmux-navigator;
          setup = ''
            vim.g.tmux_navigator_no_mappings = 0 -- Keep default Ctrl mappings enabled
          '';
        };

        conform = {
          package = conform-nvim;
          setup = pkgs.lib.readFile ./plugin/conform.lua;
        };
        harpoon =
          {
            package = harpoon;
            setup = pkgs.lib.readFile ./plugin/harpoon.lua;
          };
        tab-pin =
          {
            package = tab-pin;
            setup = ''
              require("tab-pin").setup()
              local tab_prefix = "<C-A-"
              vim.keymap.set("n", tab_prefix .. "o>", ":tabonly<CR>", { silent = true, desc = "Close all other tabs" })
              vim.keymap.set("n", tab_prefix .. "p>", ":TabPinToggle<CR>", { silent = true, desc = "Toggle Tab Pin" })
              vim.keymap.set("n", tab_prefix .. "l>", ":TabPinNext<CR>", { silent = true, desc = "Next Tab" })
              vim.keymap.set("n", tab_prefix .. "h>", ":TabPinPrev<CR>", { silent = true, desc = "Previous Tab" })
              vim.keymap.set("n", tab_prefix .. "r>", ":TabPinRename ", { silent = false, desc = "Rename Tab" })
              vim.keymap.set("n", tab_prefix .. "s>", ":TabPinSave<CR>", { silent = true, desc = "Save Tab Pins" })
              vim.keymap.set("n", tab_prefix .. "g>", ":TabPinLoad<CR>", { silent = true, desc = "Load Tab Pins" })
              '';
          };
        headlines = {
          package = headlines-nvim;
          setup = "require('headlines').setup()";
        };
        cmp = {
          package = nvim-cmp;
        };
        cmp_nvim_lsp =
          {
            package = cmp-nvim-lsp;
          };
        # avante = {
        #    package = avante-nvim;
        #     after = ["codecompanion"];
        #      setup = pkgs.lib.readFile ./plugin/ai.lua;
        #  };
        codecompanion = {
          package = codecompanion-nvim;
        };
        nui = { package = nui-nvim; };
        dressing = { package = dressing-nvim; };
        render-md = { package = render-markdown-nvim; };
      };
    # rust = {
    #    package = rustaceanvim;
    #  lspconfig = {
    #     package = nvim-lspconfig;
    #       setup = pkgs.lib.readFile ./plugin/lsp.lua;
    #       after = [ "cmp" "cmp_nvim_lsp" "rust" ];
    #      };
    #  };
    extraPackages = with pkgs;[
      cargo
      rustc
      gopls
      pyright
      clang
      zls
      sqls
      typescript-language-server
      vscode-langservers-extracted
      jdt-language-server
      rust-analyzer
      nixpkgs-fmt
      nil
      cmake-language-server
      superhtml
      rubyPackages_3_4.htmlbeautifier
      jsbeautifier
      html-tidy
      stylua
      prettierd
      rustfmt
      xclip
      wl-clipboard
      luajitPackages.lua-lsp
      nixd
      ripgrep
      vscode-langservers-extracted
    ];
    #  optPlugins = with pkgs.vimPlugins; [
    #    nvim-web-devicons
    # nvim-java
    # luasnip
    # nvim-cmp
    # cmp-nvim-lsp
    # rust-tools-nvim
    # nvim-comment
    # headlines-nvim
    # nvim-web-devicons
    # crates-nvim
    # plenary-nvim
    # dracula-nvim
    # nvim-snippy
    # nvim-dap
    # nvim-dap-ui
    # ];
    #    additionalRuntimePaths = [
    #       ./nvim/lua
    #       ./nvim
    #     ];
    #     extraConfigLua = ''
    #       ${builtins.readFile ./lua/set.lua}
    #       ${builtins.readFile ./lua/remap.lua}
    #     '';
    luaConfigRC = {
      remap = pkgs.lib.readFile ./lua/remap.lua;
   #   quick = pkgs.lib.readFile ./lua/quick_macros.lua;
      set = pkgs.lib.readFile ./lua/set.lua;
      lsp = pkgs.lib.readFile ./lua/lsp.lua;
      autocmds = pkgs.lib.readFile ./lua/autocmds.lua;

    };
  };
}








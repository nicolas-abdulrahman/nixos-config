{ pkgs, ... }:
let
  tabbys-package = pkgs.vimUtils.buildVimPlugin {
    name = "tabbys-nvim";
    src = ./my-plugins/tabbys;
  };
in
{
  config.vim = {
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
      telescope-nvim
    ];
    extraPlugins = with pkgs.vimPlugins;{
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
      neo_tree = {
        package = neo-tree-nvim;
        setup = ''
          require('neo-tree').setup()
          vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
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
      headlines = {
        package = headlines-nvim;
        setup = "require('headlines').setup()";
      };
      cmp = {
        package = nvim-cmp;
      };
      lspconfig = {
        package = nvim-lspconfig;
        setup = pkgs.lib.readFile ./plugin/lsp.lua;
        after = [ "cmp" ];
      };
    };
    extraPackages = with pkgs;[

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
    optPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
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
    ];
    additionalRuntimePaths = [
      ./nvim/lua
      ./nvim
    ];
    luaConfigRC = {
      remap = pkgs.lib.readFile ./lua/remap.lua;
      set = pkgs.lib.readFile ./lua/set.lua;
      lsp = pkgs.lib.readFile ./lua/lsp.lua;
    };
  };
}





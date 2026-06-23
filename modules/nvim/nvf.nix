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
        keys = [{ mode = "n"; key = "<leader>x"; action = ":AerialToggle<CR>"; }];
      };
    };

    extraPlugins = with pkgs.vimPlugins; {
           fzf = { package = telescope-fzf-native-nvim; };
      telescope = { package = telescope-nvim; after = [ "fzf" ]; setup = builtins.readFile ./plugin/telescope.lua; };
      notify = { package = nvim-notify; };
      neo_tree = { package = neo-tree-nvim; setup = "vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', {noremap=true})"; after = [ "icons" ]; };
      conform = { package = conform-nvim; setup = builtins.readFile ./plugin/conform.lua; };
      harpoon = { package = harpoon; setup = builtins.readFile ./plugin/harpoon.lua; };
      cmp = { package = nvim-cmp; };
      codecompanion = { package = codecompanion-nvim; };
      nui = { package = nui-nvim; };
      dressing = { package = dressing-nvim; };
    };

    luaConfigRC = {
      remap = builtins.readFile ./lua/remap.lua;
      set = builtins.readFile ./lua/set.lua;
      lsp = builtins.readFile ./lua/lsp.lua;
      autocmds = builtins.readFile ./lua/autocmds.lua;
    };

    startPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      telescope-nvim
    ];

    extraPackages = with pkgs; [
      lua-language-server # lua_ls
      gopls pyright clang-tools zls sqls typescript-language-server nixd ripgrep
      stylua prettierd rust-analyzer

    ];


    treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    
    # Use the 'grammars' option defined in your module
    };
  };
}

{ pkgs, ... }: { # <-- Removed geminiKeyPath entirely!
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

      "flash.nvim" = {
        package = pkgs.vimPlugins.flash-nvim;
        setupModule = "flash";
        
        # 1. Map 's' and 'S' to activate flash jump and treesitter select
        keys = [
          { mode = [ "n" "x" "o" ]; key = "s"; action = "<cmd>lua require('flash').jump()<cr>"; }
          { mode = [ "n" "x" "o" ]; key = "S"; action = "<cmd>lua require('flash').treesitter()<cr>"; }
        ];

        # 2. Add some nice default configurations
        setupOpts = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search = {
            mode = "search"; # Matches your exact search input string
            incremental = true;   
            multi_window = true; # Let's you jump across split panes instantly
          };
          jump = {
            autojump = false; 
          };
          modes = {
            char = {
              enabled = false; 
            };
          };
        };
      };


      "nui.nvim" = {
        package = pkgs.vimPlugins.nui-nvim;
        lazy = true;
      };




}

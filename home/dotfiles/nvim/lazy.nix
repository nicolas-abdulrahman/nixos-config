 { pkgs, ... }: {
      "aerial.nvim" = {
        package = pkgs.vimPlugins.aerial-nvim;
        setupModule = "aerial";
        setupOpts = { backends = [ "lsp" "markdown" ]; };
        cmd = [ "AerialOpen" ];
        event = [ "BufEnter" ];
        keys = [
          { mode = "n"; key = "<A-x>"; action = ":AerialToggle<CR>"; }
          { mode = "n"; key = "<A-j>"; action = ":AerialNext<CR>"; }
          { mode = "n"; key = "<A-k>"; action = ":AerialPrev<CR>"; }
        ];
      };

      "neo-tree.nvim" = {
        package = pkgs.vimPlugins.neo-tree-nvim;
        setupModule = "neo-tree";
        cmd = [ "Neotree" ];
        keys = [
          { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; }
        ];
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
        keys = [
          { mode = [ "n" "x" "o" ]; key = "s"; action = "<cmd>lua require('flash').jump()<cr>"; }
          { mode = [ "n" "x" "o" ]; key = "S"; action = "<cmd>lua require('flash').treesitter()<cr>"; }
        ];
        setupOpts = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search = {
            mode = "search";
            incremental = true;
            multi_window = true;
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

      # Git Diff & History Browser
      "diffview.nvim" = {
        package = pkgs.vimPlugins.diffview-nvim;
        setupModule = "diffview";
        cmd = [
          "DiffviewOpen"
          "DiffviewClose"
          "DiffviewToggleFiles"
          "DiffviewFocusFiles"
          "DiffviewFileHistory"
        ];
        keys = [
          { mode = "n"; key = "<leader>gh"; action = ":DiffviewFileHistory %<CR>"; } # History of current file
          { mode = "n"; key = "<leader>gH"; action = ":DiffviewFileHistory<CR>"; }   # History of current branch
          { mode = "n"; key = "<leader>gd"; action = ":DiffviewOpen<CR>"; }          # Diff working tree vs HEAD
          { mode = "n"; key = "<leader>gq"; action = ":DiffviewClose<CR>"; }         # Close diffview
        ];
      };

      # Visual Undo Tree Browser
      "undotree" = {
        package = pkgs.vimPlugins.undotree;
        cmd = [ "UndotreeToggle" ];
        keys = [
          { mode = "n"; key = "<leader>u"; action = ":UndotreeToggle<CR>"; }
        ];
      };

      "tardis.nvim" = {
        package = pkgs.vimPlugins.tardis-nvim;
        setupModule = "tardis-nvim";
        cmd = [ "Tardis" ];
        keys = [
          { mode = "n"; key = "<leader>gt"; action = ":Tardis<CR>"; }
        ];
      };

      "vim-fugitive" = {
        package = pkgs.vimPlugins.vim-fugitive;
        cmd = [ "G" "Git" "Gclog" ];
        keys = [
                 # Open vertical diff against HEAD
          { mode = "n"; key = "<A-v>"; action = "<cmd>Gvdiffsplit<CR>"; }

          # Diff navigation (next / previous change)
          { mode = "n"; key = "<A-j>"; action = "]c"; }
          { mode = "n"; key = "<A-k>"; action = "[c"; }

          # Diff resolution (accept Left / accept Right)
          # Works in both 2-way diffs and 3-way merge conflicts
          { mode = "n"; key = "<A-h>"; action = "<cmd>lua pcall(vim.cmd, 'diffget //2') or pcall(vim.cmd, 'diffget')<CR>"; }
          { mode = "n"; key = "<A-l>"; action = "<cmd>lua pcall(vim.cmd, 'diffget //3') or pcall(vim.cmd, 'diffput')<CR>"; }

          # Prompt for a branch/commit and open that version of current file (:Gedit <branch>:%)
          {
            mode = "n";
            key = "<A-f>";
            action = ":lua vim.ui.input({ prompt = 'Branch or commit: ' }, function(b) if b and b ~= '' then vim.cmd('Gedit ' .. b .. ':%') end end)<CR>";
          }
                # File history in Quickfix
          { mode = "n"; key = "<A-g>"; action = "<cmd>0Gclog<CR>"; }

        ];
      };
    }

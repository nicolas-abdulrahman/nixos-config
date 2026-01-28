{ pkgs, lib, ... }:
{

  # programs.neovim= programs.neovim.override  {
  #         pkgs.fetchFromGitHub {
  #   owner = "ntpeters";
  #   repo = "vim-better-whitespace";
  #   rev = "984c8da518799a6bfb8214e1acdcfd10f5f1eed7";
  #   sha256 = "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk";

  # };

  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      luaFile = file: "lua << EOF\n${pkgs.lib.readFile file}\nEOF\n";
      myautocmds = pkgs.vimUtils.buildVimPlugin {
        name = "myautocmds";
        src = ./myplugins/myautocmds;
      };
      tabbys = pkgs.vimUtils.buildVimPlugin {
        name = "tabbys";
        src = ./myplugins/tabbys;
      };
      # simple-fold = pkgs.vimUtils.buildVimPlugin {
      # name = "simple-fold";
      # src = ./myplugins/simple-fold-b;
      # };
    in
    {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;


      plugins = with pkgs.vimPlugins; [
        {
          plugin = myautocmds;
          config = luaFile ./plugin/myautocmds.lua;
        }
        {
          plugin = diffview-nvim;
          config = luaFile ./plugin/diffview.lua;
        }
        {
          plugin = vim-flog;
          config = luaFile ./plugin/flog.lua;
        }
        {
          plugin = fugitive;
          config = luaFile ./plugin/fugitive.lua;
        }
        {
          plugin = gitsigns-nvim;
          config = luaFile ./plugin/gitsigns.lua;
        }
        {
          plugin = lazygit-nvim;
          config = luaFile ./plugin/lazygit.lua;
        }
        {
          plugin = conform-nvim;
          config = luaFile ./plugin/conform.lua;
        }
        {
          plugin = headlines-nvim;
          config = toLua ''require("headlines").setup()'';
        }

        {
          plugin = neo-tree-nvim;
          config = toLua ''require("neo-tree").setup()'';
        }
        nvim-lspconfig
        {
          plugin = (nvim-treesitter.withPlugins (p: [

            p.tree-sitter-nix
            p.tree-sitter-lua
            p.tree-sitter-bash
            p.tree-sitter-rust
            p.tree-sitter-vimdoc
            # nvim-treesitter.withAllGrammars
          ]));
          config = luaFile ./plugin/treesitter.lua;
        }
        {
          plugin = nvim-notify;
          config = luaFile ./plugin/notify.lua;
        }
        {
          plugin = comment-nvim;
          config = toLua ''require("nvim_comment").setup()'';
        }
        {
          plugin = telescope-nvim;
          config = luaFile ./plugin/telescope.lua;
        }
        {
          plugin = lualine-nvim;
          config = toLua ''require("lualine").setup()'';
        }

        {
          plugin = nvim-dap-ui;
          config = luaFile ./plugin/dap.lua;

        }
        {
          plugin = harpoon;
          config = luaFile ./plugin/harpoon.lua;
        }
        {
          plugin = tabbys;
          config = luaFile ./plugin/tabbys.lua;
        }
        nvim-java

        luasnip
        nvim-treesitter.withAllGrammars
        nvim-cmp
        cmp-nvim-lsp
        # rust-tools-nvim
        nvim-comment
        headlines-nvim
        nvim-web-devicons
        crates-nvim
        plenary-nvim
        dracula-nvim
        nvim-snippy
        nvim-dap
        nvim-dap-ui
        catppuccin-vim
        catppuccin-nvim
        telescope-fzf-native-nvim
      ];
      extraPackages = with pkgs; [


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
      extraConfig = ''
      
        ${pkgs.lib.readFile ./lua/nick/rpy.vim  } 
      '';
      extraLuaConfig = ''
        ${pkgs.lib.readFile ./lua/nick/autocmd.lua  } 
        ${pkgs.lib.readFile ./lua/nick/remap.lua  } 
        ${pkgs.lib.readFile ./lua/nick/set.lua  } 
        ${pkgs.lib.readFile ./lua/nick/colors.lua  } 
        ${pkgs.lib.readFile ./plugin/lsp.lua  } 
      '';
    };
}

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
        # nvim-treesitter-parsers.javascript
        nvim-treesitter.withAllGrammars
        nvim-cmp
        cmp-nvim-lsp
        rust-tools-nvim
        nvim-comment
        headlines-nvim
        nvim-web-devicons
        crates-nvim
        plenary-nvim
        # {
        # plugin = simple-fold;
        #config = toLua ''require("simple-fold").setup({})'';
        # }

        # {
        # plugin = autocmdss;
        # config = luaFile ./plugin/autocmds.lua;
        # }
        {
          plugin = conform-nvim;
          config = luaFile ./plugin/conform.lua;
        }

        # {
        # plugin = pretty-fold-nvim;
        # config = luaFile ./plugin/fold.lua;

        # }
        {
          plugin = barbar-nvim;
          config = luaFile ./plugin/tab_bar.lua;

        }
        {
          plugin = headlines-nvim;
          config = toLua ''require("headlines").setup()'';
        }

        {
          plugin = neo-tree-nvim;
          config = toLua ''require("neo-tree").setup()'';
        }
        {
          plugin = nvim-lspconfig;
          config = luaFile ./plugin/lsp.lua;
        }
        #  nvim-treesitter.withAllGrammars
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

        dracula-nvim
        nvim-snippy
        nvim-dap
        nvim-dap-ui
        {
          plugin = nvim-dap-ui;
          config = luaFile ./plugin/dap.lua;

        }
        {
          plugin = harpoon;
          config = luaFile ./plugin/harpoon.lua;
        }
        #  telescope-fzf-native-nvim
        luasnip
        #   friendly-snippets
        #    vim-nix


      ];
      extraPackages = with pkgs; [
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
      '';
    };
}

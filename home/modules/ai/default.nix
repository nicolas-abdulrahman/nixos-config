{ pkgs, lib, inputs, ... }:


let
  mcp-language-server = pkgs.buildGoModule {
    pname = "mcp-language-server";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "isaacphi";
      repo = "mcp-language-server";
      rev = "main";
      hash = "sha256-INyzT/8UyJfg1PW5+PqZkIy/MZrDYykql0rD2Sl97Gg="; # Replace with hash after initial build fail
    };
    proxyVendor= true;
    vendorHash = "sha256-5YUI1IujtJJBfxsT9KZVVFVib1cK/Alk73y5tqxi6pQ=";
    subPackages = [ "." ];
  };
  anti = pkgs.antigravity-cli.overrideAttrs (oldAttrs: rec {
      version = "1.1.27";

      src = pkgs.fetchurl {
        url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_${
          if pkgs.stdenv.hostPlatform.isAarch64 then "arm64" else "x64"
        }.tar.gz";
        hash = "sha256-+HTU9rinPC32YPWA8l+2Vvy25krb/XRuZpLoN/2aIL4=";
      };
    });
in
{
  # Ensure the CLI and required helper binaries are in PATH
  home.packages = with pkgs; [
    anti
    ripgrep     # CLI ripgrep tool
    findutils   # GNU find tool
    nodejs_26   # Needed to run NPX-based MCP servers
    jdt-language-server   # Provides the `jdtls` Java LSP server
    jdk25                 # Standard JDK for Java projects
    gopls                                    # Go
    pyright                                  # Python
    rust-analyzer                            # Rust
    nil                                      # Nix
    typescript-language-server  # TS/JS
  ];

  # 2. MCP Server Configuration (~/.gemini/config/mcp_config.json)
  home.file.".gemini/config/mcp_config.json".text = builtins.toJSON {
    mcpServers = {
      lsp = {
        command = "${pkgs.nodejs_26}/bin/npx";
        args = [ "-y" "@franmt-s/ts-lsp-mcp" ]; # General TypeScript/Language Server MCP
      };
      git = {
        command = "${pkgs.uv}/bin/uvx";
        args = [ "mcp-server-git" ];
      };

      # 2. FIXED LSPs: Added `--workspace "."` argument
      lsp-typescript = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.typescript-language-server}/bin/typescript-language-server" 
          "--" "--stdio" 
        ];
      };
      lsp-python = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.pyright}/bin/pyright-langserver" 
          "--" "--stdio" 
        ];
      };
      lsp-go = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.gopls}/bin/gopls" 
        ];
      };
      lsp-nix = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.nil}/bin/nil" 
        ];
      };
      lsp-rust = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.rust-analyzer}/bin/rust-analyzer" 
        ];
      };
      lsp-java = {
        command = "${mcp-language-server}/bin/mcp-language-server";
        args = [ 
          "--workspace" "." 
          "--lsp" "${pkgs.jdt-language-server}/bin/jdtls" 
        ];
      };
    };
  };

  # 3. Agent Rules & System Prompt (~/.gemini/GEMINI.md)
  home.file.".gemini/GEMINI.md".text = ''
    # Workspace & Tool Usage Rules

    - You are explicitly allowed and encouraged to use `find` and `ripgrep` (`rg`) commands to discover files and search codebase contents.
    - **CRITICAL FILE READING RULE:** Do NOT read the full contents of any file (via file reading tools) UNLESS you have first verified through a `ripgrep` (`rg`) search that the file is directly relevant to the current task.
    - Always prefer `rg` for text searches over scanning individual files manually.

    # Tool Usage Guidelines

  - **GIT OPERATIONS:** You MUST use the dedicated Git MCP tools (e.g., `git_status`, `git_commit`, `git_diff`, `git_log`) for all repository tasks.
  - Do NOT run `git` as a terminal bash command unless an MCP tool cannot perform the specific operation requested.
  - You are allowed to use `find` and `ripgrep` (`rg`) for codebase exploration.
  - Do NOT read full file contents unless `ripgrep` confirms the file is relevant.
  '';

  # 4. Auto-Approve Command Permissions (~/.gemini/config/settings.json)
    home.file.".gemini/antigravity-cli/settings.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "command(ls)"
        "command(find)"
        "command(rg)"
        "mcp(git/git_status)"
        "mcp(git/git_diff)"
        "mcp(git/git_diff_staged)"
        "mcp(git/git_diff_unstaged)"
        "mcp(lsp/*)"
        "mcp(lsp-typescript/*)"
        "mcp(lsp-python/*)"
        "mcp(lsp-go/*)"
        "mcp(lsp-nix/*)"
        "mcp(lsp-rust/*)"
        "mcp(lsp-java/*)"
      ];
      deny = [
        "command(rm -rf)"
        "command(sudo)"
        "command(git push)"
        "command(git reset)"
        "command(git clean)"
        "command(git)"
      ];
      # git_commit / git_add / git_reset / plain "git" bash fallback
      # deliberately left off both lists -> default to "Ask",
      # so the agent still gets to use them, but you confirm first
    };
  };
}

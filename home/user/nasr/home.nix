{pkgs,username, system, ...}:
let
  nixos_path = "/etc/nixos";
  browser = "firefox";
  fileExplorer = "pcmanfm";
  terminal = "st";

  shellAliases = {
    b = "nix build /etc/nixos#nvim";
    n = "/etc/nixos/result/bin/nvim";
    ".." = "cd ..";
    h = ''
      home-manager switch --flake ${nixos_path} .#${username}_${system}
    '';
    s = ''
        sudo nixos-rebuild switch --flake "/etc/nixos#${system}";
    '';
  };
  envExtra =
    ''
        dev(){
             nix develop ${nixos_path}/#$1
           }
         #example nix run godot4 -- godot-arg=true
         run() {
          # 1. Grab the first argument as the target app/shell name
          local target="$1"
    
          # 2. Shift the arguments list left, dropping the first argument ($1)
          shift

          # 3. Check if there are any remaining arguments left to pass
          if [ $# -eq 0 ]; then
              # No arguments passed at all (e.g., 'run godot4')
              nix run "${nixos_path}/#$target"
          elif [[ "$1" == "--" ]]; then
              # You already typed the '--' manually (e.g., 'run godot4 -- godot-arg=true') nix run "/etc/nixos/sheels/#$target" "$@"
              nix run "/etc/nixos/shells/#$target" "$@"
          else
              # Arguments exist but you omitted the '--' (e.g., 'run godot4 godot-arg=true')
              # The function cleanly injects '--' for you!
              nix run "/etc/nixos/shells/#$target" -- "$@"
          fi
      }

    '';
  sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        FILE_MANAGER = "pcmanfm";
        DEFAULT_FILE_MANAGER = "pcmanfm";
      };
in

{

    programs.git = {
      extraConfig.credential.helper = "manager";
      extraConfig.credential."https://github.com".username = "nicolas-abdulrahman";
      extraConfig.credential.credentialStore = "cache";
      userName = "nicolas-abdulrahman";
      userEmail = "nicolas.abdul.rahman@gmail.com";
      enable = true;
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      # defaultKeymap = "vicmd";
      dirHashes = {
        docs = "$HOME/Documents";
        vids = "$HOME/Videos";
        dl = "$HOME/Downloads";
        imgs = "$HOME/images";
      };
      historySubstringSearch = {
        enable = true;
      };
      inherit envExtra sessionVariables shellAliases;
      initExtra = ''
      if [ -f /run/secrets/gemini_api_key ]; then
    export GEMINI_API_KEY=$(cat /run/secrets/gemini_api_key)
    export GEMINI_API_KEY_NASR=$(cat /run/secrets/gemini_api_key_nasr)
    export AVANTE_GEMINI_API_KEY="$GEMINI_API_KEY"
    export GITHUB_TOKEN=$(cat /run/secrets/ghp_nasr)
    export NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN"
    export AIDER_MODEL="gemini/gemma-4-31b-it"
fi
          '';
      oh-my-zsh = {
        extraConfig = "AGNOSTER_PROMPT_SEGMENTS=prompt_git";
        enable = true;
        theme = "agnoster";
        plugins = [
          "colorize"
          "cp"
          "sudo"
          "git"
        ];
      };
      profileExtra = '''';

    };


  nix.package = pkgs.nix;
}

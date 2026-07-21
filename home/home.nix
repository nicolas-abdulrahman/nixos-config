{ config, pkgs, inputs, lib, hypr, full,username, ... }:
let

  nixos_path = "/etc/nixos";
  browser = "firefox";
  fileExplorer = "pcmanfm";
  terminal = "st";

  username = "nick";
  shellAliases = {
    b = "nix build /etc/nixos#nvim";
    n = "/etc/nixos/result/bin/nvim";
    ".." = "cd ..";
    h = ''
      home-manager switch --flake ${nixos_path}
      # nix build ${nixos_path}/#homeConfigurations."${username}".activationPackage -o ${nixos_path}/result
      # ${nixos_path}/result/activate
    '';
  };
  envExtra =
    ''
          s(){
            sudo nixos-rebuild switch --flake "/etc/nixos#$1";
          } # <-- Fixed "$1}" to "$1" and added a semicolon
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


  options = {
    full = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
        description = "full home";
      };

    hypr = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "is using hyprland?";

    };
    
  };
  imports = [
    ./user/nasr
    ./config
    ./pkgs.nix
    inputs.nixcord.homeModules.nixcord
  ];

  config = {
    hypr  = hypr;
    full = full;
    home.username = username;
    home.homeDirectory = /home/${username};
    home.stateVersion = "26.05";



xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    application/pdf=okular.desktop   # you can change this
    text/html=${browser}.desktop
    x-scheme-handler/http=${browser}.desktop
    x-scheme-handler/https=${browser}.desktop
    x-scheme-handler/about=${browser}.desktop
    x-scheme-handler/unknown=${browser}.desktop
    inode/directory=${fileExplorer}.desktop
  '';

  # Portal configuration (for file chooser dialogs)
  xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    default=gtk
    # If you want the file chooser to use pcmanfm-qt, you'd need the portal backend,
    # but gtk is fine for a lightweight setup.
  '';
    home.sessionVariables = sessionVariables;
    home.file = {
      ".aider.conf.yml".text = ''
    # Recommended settings for a coding agent

    auto-commits: true
    edit-format: diff
  '';
        ".config/nvf/avanterules/default.avanterules".text = "dont wast tokens";
      ".config/nvim/avanterules/default.avanterules".text = "dont waste tokens";
    # Option 1: For older versions using settings.json
    ".gemini/settings.json".text = ''
      {
        "excludeTools": [
          "google_web_search"
        ]
      }
    '';

    # Option 2: For newer versions using the TOML policy engine
    ".gemini/policies/disable-search.toml".text = ''
      [[rule]]
      toolName = "google_web_search"
      decision = "deny"
      priority = 100
    '';
  };

   
    programs.bash = {
      enable = true;
      enableCompletion = true;
      inherit shellAliases;
      bashrcExtra = envExtra;
    };

  # Optional: If you want it to start automatically when you log in
    services.openhands.enable = false;

  };
}

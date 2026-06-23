{ config, pkgs, inputs, lib, username, ... }:
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
    let
      myString = "\${@:2}";
    in
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
              nix run "/etc/nixos/sheels/#$target" "$@"
          else
              # Arguments exist but you omitted the '--' (e.g., 'run godot4 godot-arg=true')
              # The function cleanly injects '--' for you!
              nix run "/etc/nixos/sheels/#$target" -- "$@"
          fi
      }

    '';
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
    ./modules
    ./pkgs.nix
    inputs.nixcord.homeModules.nixcord
  ];

  config = {
    home.username = username;
    home.homeDirectory = /home/${username};
    home.stateVersion = "26.05";
    programs.vscode = lib.mkIf (config.full) {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        editorconfig.editorconfig
        dbaeumer.vscode-eslint
        stylelint.vscode-stylelint
        zainchen.json
      ];
    };

    #
    # xdg.portal = {
    #   enable = true;
    #
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-hyprland
    #     # xdg-desktop-portal-gtk
    #   ];
    #
    #   xdgOpenUsePortal = true;
    #
    #   config = {
    #     hyprland = {
    #       default = [ "hyprland" ];
    #     };
    #   };
    # };

    # xdg.portal = {
    #   enable = true;
    #   extraPortals = lib.mkForce
    #     (with pkgs; [
    #       kdePackages.xdg-desktop-portal-kde
    #       xdg-desktop-portal-gtk # Fallback for GTK apps
    #       pkgs.xdg-desktop-portal-hyprland
    #     ]);
    #   xdgOpenUsePortal = true;
    #   config = {
    #     hyprland.default = [ "hyprland" ];
    #   };
    #
    #   # gtkUsePortal = true;
    #
    # };


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
    home.sessionVariables = {
      WARP_PATH = "${pkgs.warp-terminal}/bin/warp-terminal"; # Or the correct binary path
    };

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
      # dotDir = ".config/zsh";
      historySubstringSearch = {
        enable = true;
      };
      inherit envExtra;
      #.zshenv
      inherit shellAliases;
      #    initContent = ''
      #      \builtin alias cd=__zoxide_z
      #      \builtin alias zi=__zoxide_zi
      #       eval "$(zoxide init zsh)"  >/dev/null 2>&1
      #       export WARP_PATH="${pkgs.warp-terminal}/bin/warp-terminal"
      #    ''; #.zshrc
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

    programs.bash = {
      enable = true;
      enableCompletion = true;
      inherit shellAliases;
      bashrcExtra = envExtra;
    };

  };
}

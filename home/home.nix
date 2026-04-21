{ config, pkgs, inputs, lib, username, ... }:
let
  nixos_path = "/etc/nixos";
  browser = "google-chrome";
  username = "nick";
  shellAliases = {
    b = "nix build /etc/nixos";
    n = "/etc/nixos/result/bin/nvim";
    ".." = "cd ..";
    s = "sudo nixos-rebuild switch --flake /etc/nixos/";
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
      dev(){
          NIX_SHELL_PRESERVE_PROMPT=1 nix develop ${nixos_path}/#$1
         }
       ru(){
          NIX_SHELL_PRESERVE_PROMPT=1 nix run ${nixos_path}/#$1
       }
       run(){
           nix run nixpkgs#$1 -- ${myString}
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
    home.stateVersion = "24.11";
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
      application/pdf=okular.desktop
      text/html=${browser}.desktop
      x-scheme-handler/http=${browser}.desktop
      x-scheme-handler/https=${browser}.desktop
      x-scheme-handler/about=${browser}.desktop
      x-scheme-handler/unknown=${browser}.desktop
    '';
    xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gtk;kde
      org.freedesktop.impl.portal.FileChooser=${browser}
      org.freedesktop.impl.portal.WebBrowser=${browser}
      org.freedesktop.impl.portal.Document=okular
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

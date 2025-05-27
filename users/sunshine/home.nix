{ config, pkgs, bobox, inputs, lib, username, ... }:
let
  nixos_path = "/etc/nixos";
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
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde # Provides KDE integration (Dolphin)
        xdg-desktop-portal-gtk # Fallback for GTK apps
      ];
    };
    xdg.configFile."mimeapps.list".text = ''
      [Default Applications]
      application/pdf=okular.desktop
      text/html=opera.desktop
      x-scheme-handler/http=opera.desktop
      x-scheme-handler/https=opera.desktop
      x-scheme-handler/about=opera.desktop
      x-scheme-handler/unknown=opera.desktop
    '';
    xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gtk;kde
      org.freedesktop.impl.portal.FileChooser=dolphin
      org.freedesktop.impl.portal.WebBrowser=opera
      org.freedesktop.impl.portal.Document=okular
    '';
    home.sessionVariables = {
      WARP_PATH = "${pkgs.warp-terminal}/bin/warp-terminal"; # Or the correct binary path
    };

    # xdg.mimeApps = {
    # enable = true;

    # defaultApplications = {
    # "inode/directory" = [ "dolphin.desktop" ];
    # };
    # };

    # xdg = {
    # portal = {
    # enable = true;
    # xdgOpenUsePortal = true;
    # config = {
    # common.default = [ "gtk" "xdph" ];
    # hyprland.default = [ "gtk" "hyprland" ];
    # };
    # extraPortals = [
    # pkgs.xdg-desktop-portal-gtk
    # pkgs.xdg-desktop-portal-kde
    # pkgs.xdg-desktop-portal-hyprland
    # ];
    # };
    # };

    # xdg.configFile."mimeapps.list".force = true;
    # home-manager.backupFileExtension = "backup";


    programs.git = {
      extraConfig.credential.helper = "manager";
      extraConfig.credential."https://github.com".username = "HappyySunshine";
      extraConfig.credential.credentialStore = "cache";
      enable = true;
      # userName = "happyysunshine";
      # userEmail = "happysunshine.pone@gmail.com";
      userName = "Nicolas-Hugo Ferreira Ouellet";
      userEmail = "13525119932@ulife.com.br";
    };

    home.packages = with pkgs; [
      gitkraken
      dbeaver-bin
      warp-terminal
      blender
      steamcmd
      audacity
      git-credential-manager
      pavucontrol
      tmux
      vdhcoapp
      universal-ctags
      # Network
      arp-scan
      nmap
      kitty
      swayimg
      xorg.xrandr
      brightnessctl
      zoxide
      radare2
      openbox
      broot
      nnn
      steam-run
      firefox
      discord
      lutris
      godot_4
      qbittorrent
      floorp
      android-tools
      google-chrome
      brave
    ] ++ (if config.hypr then [
      grimblast
      mako
      waybar
      eww
      hyprpaper
      hyprlock
      hypridle
    ] else [ ])
    ++ (if config.full then [
      smartgithg
      opera
      libsForQt5.okular
      weston
      gamescope
      protonup-qt
      vesktop
      gimp
      # notion
      blender
      krita
      waydroid
      wireshark
      metabase
      texliveFull
      prismlauncher
      # launcher
      # bobox.grapejuice
      thunderbird
      android-studio
      wireshark
      whatsie
      spotify
      waydroid
      libreoffice-qt6

    ] else [ ]);

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      defaultKeymap = "vicmd";
      dirHashes = {
        docs = "$HOME/Documents";
        vids = "$HOME/Videos";
        dl = "$HOME/Downloads";
        imgs = "$HOME/images";
      };
      dotDir = ".config/zsh";
      historySubstringSearch = {
        enable = true;
      };
      #.zshenv
      envExtra =
        let
          myString = "\${@:2}";
        in
        ''
          dev(){
              NIX_SHELL_PRESERVE_PROMPT=1 nix develop ${nixos_path}/root/shells/$1
              zsh
             }
           run(){
               nix run nixpkgs#$1 -- ${myString}
           }
        '';
      initExtra = ''
        \builtin alias cd=__zoxide_z
        \builtin alias zi=__zoxide_zi
         eval "$(zoxide init zsh)"
         clear
          export WARP_PATH="${pkgs.warp-terminal}/bin/warp-terminal"
      ''; #.zshrc
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
      shellAliases = {
        ".." = "cd ..";
        s = "sudo nixos-rebuild switch --flake /etc/nixos/";
        h = ''
          home-manager switch --flake ${nixos_path}
          # nix build ${nixos_path}/#homeConfigurations."${username}".activationPackage -o ${nixos_path}/result
          # ${nixos_path}/result/activate
        '';
      };
      profileExtra = '''';

    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        dev(){
               nix develop /etc/nixos/root/shells/$1
               echo "ready to code $1!"
               }
      '';

      bashrcExtra = lib.mkDefault ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';
      # loginShellInit = "source ./scripts/alias.sh";

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        s = "sudo nixos-rebuild switch --flake /etc/nixos/";
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };

  };
  # a regex pattern

  # starship - an customizable prompt for any shell
}

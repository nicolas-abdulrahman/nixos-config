{ config, pkgs, inputs, nixgl, lib,isFull, useHypr, hardwareFile, ... }:

{
  imports = [
    hardwareFile
    inputs.sops-nix.nixosModules.sops # <-- This makes the 'sops' option exist!
    ./boot.nix
    ./desktop_manager.nix
    ./pkgs.nix
    ./security.nix
    ./users.nix
  ];

  options = {
    full = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable full comprehensive suite configuration flag.";
    };
    hypr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland ecosystem settings configuration flag.";
    };
  };

  config = {
    full = isFull;
    hypr = useHypr;
    services.envfs.enable = true;
    services.httpd = lib.mkIf (config.full) {
      enablePHP = true;
      enable = true;
      extraConfig = ''
        Alias /hello "/programs/codes/php/hello"
        Alias /rua_solidaria "/programs/codes/node/Prototipo-rua-solidaria"

        <Directory "/programs/codes/php/hello">
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>

        <Directory "/programs/codes/node/Prototipo-rua-solidaria">
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>
      '';
    };
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    programs.steam = lib.mkIf (config.full) {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.nix-ld.enable = true;
    programs.dconf.enable = true;
    programs.zsh.enable = true;

    time.timeZone = "America/Recife";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    services.gnome.gnome-keyring.enable = true;
    services.printing.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.hack
      openmoji-color
      gentium
      cantarell-fonts
      textfonts
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [ "Hack" ];
      emoji = [ "OpenMoji Color" ];
    };

    hardware = {
      pulseaudio.enable = false;
      uinput.enable = true;
      opengl.enable = true;
    };

    system.stateVersion = "26.05";

     services.kanata = {
      enable = true;

      keyboards.default = {
        devices = [
      "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.3:1.1-event-kbd"
      "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.4:1.0-event-kbd"
    ];
        configFile=  ./conf/keys.kbd;
      };
    }; 
    systemd.services."kanata-default".wantedBy = [ "multi-user.target" ];

  };
}

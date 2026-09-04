{ config, pkgs, inputs, nixgl, lib, useHypr, hardwareFile, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops # <-- This makes the 'sops' option exist!
    ./cli.nix
    ./users.nix
    ../modules/kanata
    
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
    xserver= lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable X.";
    };
    docker= lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable docker";
    };
    remap= lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable remap";
    };
    kanata= lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable services";
    };
  };
  config = {
    virtualisation.docker = {
      enable = config.docker;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
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

  };
}

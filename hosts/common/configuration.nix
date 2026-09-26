{ config, pkgs, inputs, users,  lib,   ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops # <-- This makes the 'sops' option exist!
    ./users.nix
    ../modules/kanata
    ./desktop_manager.nix
    ./gui.nix
    ./security.nix
    
  ];

  options = {
    hypr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland.";
    };
    hostUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "System users to create on this host.";
    };
    docker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualization (docker).";
    };
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop-specific hardware and drivers (AMDGPU, desktop peripherals).";
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

    environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

    

    
    nix.package = pkgs.lix;

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      glib
      libGL
      libX11
      libXcursor
      libXext
      libXinerama
      libXrandr
      libXrender
      libxi
      libxkbcommon
      openssl
      vulkan-loader
      zlib
    ];
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
       noto-fonts 
      ibm-plex

      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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

    services.pulseaudio.enable = false;

    hardware = {
      uinput.enable = true;
      graphics.enable = true;
    };

    system.stateVersion = "26.11";
    xdg.portal.enable = true;
  };
}

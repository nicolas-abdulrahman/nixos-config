{ config, pkgs, inputs, nixgl, lib, ... }:
#let 
#    myjdk21 = pkgs.jdk21;
#in
{

  imports =
    [
      ./jupyter.nix
      ./hardware-configuration.nix
      ./boot.nix
      ./desktop_manager.nix
      ./pkgs.nix
      ./network.nix
      ./users.nix
    ];
  options = {

    full = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
        description = "full nixos";
      };

    laptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "am i using da laptop?";
    };
  };


  config = {
    # virtualisation = lib.mkIf (config.full) {
    #   vmware.host.enable = true;
    #   virtualbox.host.enableKvm = false; # Disable KVM for VirtualBox
    #   virtualbox.host.addNetworkInterface = false; # Disable network interface for KVM
    #   virtualbox.host.enable = true;
    #   docker.enable = true;
    #   waydroid.enable = true;
    # };
    services.httpd = lib.mkIf (config.full) {
      enablePHP = true;
      enable = true;
      extraConfig = ''
        # Serve /hello from /codes/mywebsite
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
    nix.settings.trusted-users = [ "root" "sunshine" ];
    users.extraGroups.vboxusers.members = [ "sunshine" ];
    programs.steam = lib.mkIf (config.full) {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # package = pkgs.steam.override {
      # withPrimus = true;
      # extraPkgs = with pkgs; [ bumblebee glxinfo ];
      # };
    };
    programs.nix-ld.enable = true;
    hardware.uinput.enable = true;


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

    programs.dconf.enable = true;
    services.gnome = {
      gnome-keyring.enable = true;
    };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
    };


    # xdg.mime.defaultApplications = {
    #   "application/pdf" = [ "okular.desktop" ];
    #   "text/html" = [ "firefox.desktop" ];
    #   "x-scheme-handler/http" = [ "firefox.desktop" ];
    #   "x-scheme-handler/https" = [ "firefox.desktop" ];
    # };
    #
    # # XDG Portal configuration
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-kde
    #     xdg-desktop-portal-gtk
    #   ];
    #   config.common = {
    #     default = [ "gtk" "kde" ];
    #     "org.freedesktop.impl.portal.FileChooser" = [ "dolphin" ];
    #     "org.freedesktop.impl.portal.WebBrowser" = [ "firefox" ];
    #     "org.freedesktop.impl.portal.Document" = [ "okular" ];
    #     # "org.freedesktop.impl.portal.OpenURI" = [ "kde" ];
    #   };
    # };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    services.xserver.xkb = {
      layout = "br";
      variant = "nodeadkeys";
    };
    console.keyMap = "br-abnt2";
    services.printing.enable = true;

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.zsh.enable = true;


    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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


    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs;[ pkgs.mesa.drivers libva-utils mesa ];
    };
    system.stateVersion = "24.11";
  };
}

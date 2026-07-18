


{ pkgs, inputs, config, lib, ... }:

{
  programs.wireshark.enable = true;

  virtualisation.docker.enable = true;


  programs.java = {
    enable = config.full;
    # package = pkgs.jdk23;
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {
        datadir = "/var/lib/mysql";
        bind-address = "127.0.0.1";
        port = 3305;
      };
    };
  };


  users.mysql = {
    enable = false;
    host = "localhost";
    user = "sunshine";
    database = "test";
    passwordFile = "/run/secrets/mysql-auth-db-passwd";
    # passwordFile = /etc/nixos/mysql-passwd;
    nss = { };
    pam = {
      table = "users";
      userColumn = "username";
      passwordColumn = "password";
      passwordCrypt = "2";


    };
  };
  programs.firejail =
    {
      enable = true;
      wrappedBinaries = {
        surf = {
          executable = "${lib.getBin pkgs.surf}/bin/surf";
          profile = "${pkgs.firejail}/etc/firejail/surf.profile";
        };
      };

    };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;[]++  (lib.optionals (config.full) [
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
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    zlib
  ]);


  environment.systemPackages = with pkgs;
# Essentials
  [
    home-manager pcmanfm  kanata
    cacert iproute2 inetutils nettools xremap tmux
    zsh git wget curl jq btop unzip file glib nix-index tree lsof st surf 
  ] ++ 
  # Optionals (System-level CLI only)
  (lib.optionals (config.full) [
    ffmpeg imagemagick 
    xorg.xorgserver xorg.xinit xorg.xrandr xorg.xsetroot xorg.xev
  ]);
}

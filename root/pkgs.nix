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
        firefox = {
          executable = "${lib.getBin pkgs.firefox}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
        vesktop = {
          executable = "${pkgs.vesktop}/bin/vesktop";
          profile = "${pkgs.firejail}/etc/firejail/vesk.profile";
          extraArgs = [
            "--enable-features=UseOzonePlatform"
            "--ozone-platform=wayland"
            "--disable-x11"
            "--no-sandbox"
          ];
        };
      };

    };
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
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    zlib
  ];


  environment.systemPackages = with pkgs; [
    cacert  # Provides standard security certificates
    xorg.xorgserver
    xorg.libX11
    xorg.xinit
    xwayland
    xorg.xrandr
    xorg.xsetroot
    kdePackages.plasma-workspace


    xorg.xev
    xremap
    iproute2
    lsof
    xorg.libX11
    inetutils
    nettools
    docker
    home-manager
    tree
    treecat
    patchelf
    file
    bubblewrap
    firejail
    glib

    nix-index
    glibc
    docker-compose
    firefox
    btop
    unzip
    imagemagick
    # vdhcoapp
    ffmpeg
    libnotify
    broot
    neofetch
    nixd
    neovim
    git
    zsh
    wget
    curl
    zsh
    jq
    gparted
  ] ++ (lib.optionals (config.full) [

    wineWowPackages.full
    slurp
    grim
    devbox
    #  vdhcoapp #firefox plugin to download vids
    # kdePackages.xwaylandvideobridge
    kdePackages.dolphin
    gradle
    prismlauncher
    bun
    lua
    rust-analyzer-unwrapped
    python314
    luajitPackages.lua-lsp
    vscode
    gdb
    gdb-dashboard
    inputs.nixgl

  ]);
}

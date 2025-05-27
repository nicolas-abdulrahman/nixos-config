{ pkgs, inputs, config, lib, ... }:

{
  programs.wireshark.enable = true;

  virtualisation.docker.enable = true;
  users.users.sunshine.extraGroups = [ "docker" ];


  programs.java = {
    enable = config.full;
    package = pkgs.jdk23;
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
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

  environment.systemPackages = with pkgs; [
    inetutils
    unixtools.nettools
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
    vdhcoapp
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
    vdhcoapp #firefox plugin to download vids
    kdePackages.xwaylandvideobridge
    kdePackages.dolphin
    gradle
    prismlauncher
    bun
    lua
    rust-analyzer-unwrapped
    clang-tools_16
    python314
    luajitPackages.lua-lsp
    vscode
    gdb
    gdb-dashboard
    inputs.nixgl

  ]);
}

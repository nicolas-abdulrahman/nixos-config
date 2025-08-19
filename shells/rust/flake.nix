{
  description = "A very basic flake";
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs2.url = github:nixos/nixpkgs;
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # pkgs2 = import nixpkgs2 {inherit system;};
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs;[
          gdb
          pkgs.cargo
          pkgs.rustc # glibc
          pkgs.cargo-expand
          pkgs.rust-analyzer
        ];

        nativeBuildInputs = [ pkgs.pkg-config pkgs.cargo pkgs.ninja pkgs.protobuf ];
        buildInputs = with pkgs;[
          gtk4
          #   #openssl_3_1
          #   openssl_legacy
          #   dbus
          #   libxkbcommon
          #   python3
          #   libGL
          #   alsa-lib
          #    ocamlPackages.ssl
          #    WINIT_UNIX_BACKEND=wayland
          #   wayland
          #    WINIT_UNIX_BACKEND=x11
          #   xorg.libXcursor
          #   xorg.libXrandr
          #   xorg.libXi
          #   xorg.libX11
          #   qt6Packages.qxlsx
          #   graphene  
          #   protobuf
          #   sbclPackages.cl-gtk2-glib
          #   pkgs.lldb
          #   pkgs2.lldb   
          #   pkgs.pkg-config-unwrapped
          #   pkgs.libclang 
          #
        ];
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        shellHook = "zsh";
      };

    };
}


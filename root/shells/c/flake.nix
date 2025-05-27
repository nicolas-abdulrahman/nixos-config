{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        hardeningDisable = [ "all" ];
        packages = with pkgs;[
          python3
          llvmPackages_16.clang-unwrapped
          gccgo13
          cmake
          gnumake
          bear

        ];
        nativeBuildInputs = [ ];
        buildInputs = with pkgs;[
          dbus
          libxkbcommon
          libGL
          ocamlPackages.ssl

          # WINIT_UNIX_BACKEND=wayland
          wayland

          # WINIT_UNIX_BACKEND=x11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          xorg.libX11
        ];

        CLANGD_PATH = pkgs.llvmPackages_16.clang-unwrapped;

        #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
      };

    };
}


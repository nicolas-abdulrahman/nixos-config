{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs;[
          # qtcreator
          # clang
          cmake

          # gcc14
          # gcc13
          qt6.qtbase
          qt6.full
          qtcreator

          # this is for the shellhook portion
          qt6.wrapQtAppsHook
          makeWrapper
          bashInteractive
          # qt6Packages.qt6
          # qt6.full

        ];

        shellHook = ''
          export QT_QPA_PLATFORM=wayland
          bashdir=$(mktemp -d)
          makeWrapper "$(type -p bash)" "$bashdir/bash" "''${qtWrapperArgs[@]}"
          exec "$bashdir/bash"
        '';

      };

    };
}


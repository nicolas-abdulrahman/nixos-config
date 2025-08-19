{
  description = "Two zsh-based shells, one loads from shell.nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system}.pokemon = {
        type = "app";
        program = "${pkgs.krabby}/bin/krabby";
      };
      devShells.${system} = {
        java = import ./java.nix { inherit pkgs; };
        node = import ./node.nix { inherit pkgs; };
        python = import ./python.nix { inherit pkgs; };
        rust = import ./rust.nix { inherit pkgs; };
        wine = import ./wine.nix { inherit pkgs; };
        zig = import ./zig.nix { inherit pkgs; };
      };
    };
}


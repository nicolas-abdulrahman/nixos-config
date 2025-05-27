{
  description = "blender 4";
  inputs = {
    # nixpkgs.url = "github.com/NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [ renpy ];
      };
    };
}


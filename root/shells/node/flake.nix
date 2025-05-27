{
  description = "blender 4";
  inputs = {
    # nixpkgs.url = "github.com/NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    bunpkgs.url = "github:nixos/nixpkgs/fab09085df1b60d6a0870c8a89ce26d5a4a708c2";
  };
  outputs = { self, nixpkgs, bunpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs2 = import bunpkgs { inherit system; };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [

          nodejs_22
          typescript
          pnpm
          #javascript-typescript-langserver
          nodePackages_latest.typescript-language-server
          pkgs2.bun
          # nodePackages.sass
        ];
        #GOPLS_PATH = "${pkgs.gopls}/bin/gopls"; 
      };
    };
}


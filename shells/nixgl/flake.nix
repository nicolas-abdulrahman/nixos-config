{
  description = "blender 4";
  inputs = {
     # nixpkgs.url = "github.com/NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
  };
  outputs = { self, nixpkgs, nixgl}: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system; 
                    overlays = [nixgl.overlay];
        };
    in{
        devShells."${system}".default = pkgs.mkShell{
           packages =  [ 
                pkgs.nixgl.nixGLIntel
                 
           ];        
           #GOPLS_PATH = "${pkgs.gopls}/bin/gopls"; 
        };
     };
}


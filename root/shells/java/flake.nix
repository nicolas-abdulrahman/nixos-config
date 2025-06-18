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
        packages = with pkgs; [ jdk21 ];

        buildInputs = with pkgs; [
          maven
          jdk21
          xorg.libX11
          # customise the jdk which gradle uses by default
          (callPackage gradle-packages.gradle_8 {
            java = jdk21;

          })
        ];
        #GOPLS_PATH = "${pkgs.gopls}/bin/gopls"; 
      };

    };
}


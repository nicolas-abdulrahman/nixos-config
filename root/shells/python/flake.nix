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
        packages = [
          pkgs.python39
          pkgs.python311Packages.pip
          pkgs.pyright
          pkgs.isort
          pkgs.black
        ];
        #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
      };

    };
}


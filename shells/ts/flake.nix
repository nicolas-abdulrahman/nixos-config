{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    language-servers.url = git+https://git.sr.ht/~bwolf/language-servers.nix;
    language-servers.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, language-servers, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            nodejs-18_x
            language-servers.packages.${system}.angular-language-server
            language-servers.packages.${system}.typescript-language-server
          ];
        };
      });
}

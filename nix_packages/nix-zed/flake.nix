{
  description = "nix-zed — manage Zed editor, extensions, LSPs, and config via Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Home Manager module — the primary entry point
    homeManagerModules.default = import ./modules/home-manager.nix;
    homeManagerModules.nix-zed = import ./modules/home-manager.nix;

    # Expose helper lib for advanced use
    lib = import ./lib { inherit nixpkgs; };

    # Dev shell for contributors
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        default = pkgs.mkShell {
          packages = [ pkgs.nil pkgs.nixfmt-rfc-style ];
        };
      }
    );
  };
}

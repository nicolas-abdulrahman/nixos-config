{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/64e75cd44acf21c7933d61d7721e812eac1b5a0a";
    # hyprland.url = "github:hyprwm/hyprland/86be75dd97b5633b8c0aa6bdcb3346fa871a8480";
    hyprland.url = "github:hyprwm/hyprland/";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # xremap-flake.url = "github:xremap/nix-flake";
    # robox.url = "github:nixos/nixpkgs/190c31a89e5eec80dd6604d7f9e5af3802a58a13";
    nix-colors.url = "github:misterio77/nix-colors";
    nixgl.url = "github:nix-community/nixGL";
    #xremap-flake.url =  "/etc/nixos/my-stuff/xremap-flake";
    #  nix-index-database.url = "github:Mic92/nix-index-database";
    #  nix-index-database.follows = "nixpkgs";
    #  nixgl.url = "github:guibou/nixGL";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      bobox = import inputs.robox { inherit system; };
      hyprland = inputs.hyprland.packages.${system}.hyprland;
      pkgs = nixpkgs;
      username = "sunshine";
    in
    {
      homeConfigurations =
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          "${username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; inherit username; inherit hyprland; inherit bobox; };
            modules = [
              ./users/sunshine/home.nix
              {
                full = true;
                hypr = true;
              }
            ];
          };

        };
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; inherit hyprland; };
          modules = [
            ./root/configuration.nix
            {
              full = true;
            }
          ];
        };
        nixos-full = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; inherit hyprland; };
            modules = [
              ./root/configuration.nix
              {
                full = true;
              }
            ];

          };
      };
    };
}

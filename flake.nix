{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/9e83b64f727c88a7711a2c463a7b16eedb69a84c";
    eww.url = "github:elkowar/eww";
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
    nvf.url = "github:Outnicky/nvf-fork";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nvf.url = "path:./nix_packages/nvf";

  };

  outputs = inputs@{ nur, nixpkgs, home-manager, nvf, ... }:
    let

      system = "x86_64-linux";
      packages.${system}.myWrapped = nvf.packages.${nixpkgs.system}.default;
      bobox = import inputs.robox { inherit system; };
      hyprland = inputs.hyprland.packages.${system}.hyprland;
      username = "sunshine";
      nvim_path = ./modules/nvim;
      pkgs = import nixpkgs {
        inherit system;
      };
      ewwWrapper =
        let
          ewwModule = import ./modules/eww/eww.nix;
          config.eww.enable = true;
          ewwEval = (nixpkgs.lib.evalModules {
            modules = [ ewwModule config ];
            specialArgs = { inherit pkgs; };
          }).config;
        in
        ewwEval.eww.run;
    in
    {
      packages.${system} =
        {
          default =
            (nvf.lib.neovimConfiguration {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./modules/nvim/nvf.nix
              ];
            }).neovim;

          ewwWrapper = ewwWrapper;
        };

      apps.${system}.eww = {
        type = "app";
        program = "${ewwWrapper}/bin/eww";
      };
      homeConfigurations =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nur.overlays.default ];
            config = {
              allowUnfree = true;
              # permittedInsecurePacakges = [ "dotnet-sdk-6.0.428" ];
              permittedInsecurePackages = [ "dotnet-sdk-6.0.428" ];
              allowInsecurePredicate = _: true;
            };
          };
        in
        {
          "${username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; inherit username; inherit hyprland; };
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
      devShells.${system} =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          java = import ./shells/java.nix { inherit pkgs; };
          node = import ./shells/node.nix { inherit pkgs; };
          python = import ./shells/python.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
          wine = import ./shells/wine.nix { inherit pkgs; };
          zig = import ./shells/zig.nix { inherit pkgs; };
        };
    };
}

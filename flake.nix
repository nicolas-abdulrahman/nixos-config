{


  description = "NixOS configuration";
  inputs = {

    # nixpkgs.url = "github:nixos/nixpkgs/9e83b64f727c88a7711a2c463a7b16eedb69a84c";
    nixpkgs.url = "github:nixos/nixpkgs/";
    eww.url = "github:elkowar/eww";
    # hyprland.url = "github:hyprwm/hyprland/bef1321f00e260ee3031aecd02faf4f53bcb5c66";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/hyprland/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixgl.url = "github:nix-community/nixGL";
    #   nix-index-database.url = "github:Mic92/nix-index-database";
    #   nix-index-database.follows = "nixpkgs";
    # nvf.url = "github:Outnicky/nvf-fork?ref=nick";
    nvf.url = "github:Outnicky/nvf-fork";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:FlameFlag/nixcord";
    nix-zed = {
        url = "path:./nix_packages/nix-zed";
        inputs.nixpkgs.follows = "nixpkgs";
      };

  };

  outputs = inputs@{ nur, nixpkgs, home-manager, nvf, ... }:
    let

      system = "x86_64-linux";
      packages.${system}.myWrapped = nvf.packages.${nixpkgs.system}.default;
      bobox = import inputs.robox { inherit system; };
      hyprland = inputs.hyprland.packages.${system}.hyprland;
      username = "nick";
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
            let
              # 1. Your existing nvf configuration
              nvfPkg = (nvf.lib.neovimConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                modules = [ ./modules/nvim/nvf.nix ];
              }).neovim;
              GEMINI_API_KEY = "AIzaSyBFM6qm8HopurT5NU-TDPYuE1XPU3RYdm4:3"; # better: use sops-nix

              pkgs = nixpkgs.legacyPackages.x86_64-linux;
            in
            pkgs.symlinkJoin {
              name = "nvim";
              paths = [ nvfPkg ];
              buildInputs = [ pkgs.makeWrapper ];
              postBuild = ''
                # Rename the original binary so we can put our script in its place
                mv $out/bin/nvim $out/bin/nvim-unwrapped
                makeWrapper $out/bin/nvim-unwrapped $out/bin/nvim \
                  --argv0 "nvim" \
                  --run 'export AVANTE_GEMINI_API_KEY="${GEMINI_API_KEY}"' \
                  --run 'export GEMINI_API_KEY="${GEMINI_API_KEY}"' \

              '';
            };

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
              ./home/home.nix
              inputs.nix-zed.homeManagerModules.nix-zed
              {
                # laptop = true;
                full = false;
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
            config.allowUnfree = true;
          };
        in
        {
          c = import ./shells/c.nix { inherit pkgs; };
          java = import ./shells/java.nix { inherit pkgs; };
          node = import ./shells/node.nix { inherit pkgs; };
          python = import ./shells/python.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
          wine = import ./shells/wine.nix { inherit pkgs; };
          zig = import ./shells/zig.nix { inherit pkgs; };
          zed = import ./modules/zed { inherit pkgs; };
          vscode = import ./shells/vscode { inherit pkgs; };
        };
    };
}

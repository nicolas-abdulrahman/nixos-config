{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/";
    eww.url = "github:elkowar/eww";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixgl.url = "github:nix-community/nixGL";
    nvf.url = "github:NotAShelf/nvf";
    nur.url = "github:nix-community/NUR";
    nixcord.url = "github:FlameFlag/nixcord";
    nix-zed = {
      url = "path:./nix_packages/nix-zed";


      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Bleeding edge
    sops-nix.url = "github:Mic92/sops-nix";
    
    continue = {
    url = "github:continuedev/continue";
    flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, nvf, home-manager, nur, nixpkgs-unstable, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # Keep your insecure packages here too
          permittedInsecurePackages = [ "dotnet-sdk-6.0.428" ];
        };
      };
      pkgs-unstable = import nixpkgs-unstable{
        inherit system;
      };
      username = "nick";

      customPkgs = pkgs.extend (final: prev: {
        continue-nvim = prev.vimUtils.buildVimPlugin {
          pname = "continue.nvim";
          version = "latest";
          src = inputs.continue; # Pulls directly from flake inputs here safely!
        };
      });

      nvfPkg = (nvf.lib.neovimConfiguration {
        pkgs = customPkgs;
        modules = [
          ./modules/nvim/nvf.nix ];
      }).neovim;

      myNvim = pkgs.symlinkJoin {
        name = "nvim";
        paths = [ nvfPkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          mv $out/bin/nvim $out/bin/nvim-unwrapped
          makeWrapper $out/bin/nvim-unwrapped $out/bin/nvim \
            --argv0 "nvim" \
            --set AVANTE_GEMINI_API_KEY "YOUR_ACTUAL_API_KEY" \
            --set GEMINI_API_KEY "YOUR_ACTUAL_API_KEY"
        '';
      };


      godotModule = import ./shells/godot4 { inherit pkgs pkgs-unstable; nixgl = nixgl.packages.${system}.nixGLIntel; nvim= myNvim; };
      godotModule2 = import ./shells/godot { pkgs = pkgs-unstable; };
    in
    {
    
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username godotModule; nvim=nvfPkg; hyprland = inputs.hyprland;
          full = true;
          hypr = true;
        };
        modules = [
          ./home/home.nix
          ./modules/openhands
          inputs.nix-zed.homeManagerModules.nix-zed
          
        ];
      };


      nixosConfigurations =
        let
          system = "x86_64-linux"; # Adjust if your systems differ

          # Define a helper function to build systems without repeating boilerplate
          mkSystem = { hardwareFile, isFull, useHypr }: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs isFull useHypr hardwareFile;
              hyprland = inputs.hyprland;
            };
            modules = [ ./root/configuration.nix 

            ];
          };
        in
        {
          nixos= mkSystem {
            hardwareFile = ./root/hardware-configuration.nix;
            isFull = true;
            useHypr = true;
          };

          laptop = mkSystem {
            hardwareFile = ./root/laptop-hardware-configuration.nix;
            isFull = false;
            useHypr = false;
          };
        };


      packages.${system} = {
        nvim = nvfPkg;
        godot = godotModule.app;
      };

      devShells.${system} = {
        c = import ./shells/c.nix { inherit pkgs; };
        java = import ./shells/java.nix { inherit pkgs; };
        node = import ./shells/node.nix { inherit pkgs; };
        python = import ./shells/python.nix { inherit pkgs; };
        rust = import ./shells/rust.nix { inherit pkgs; };
        wine = import ./shells/wine.nix { inherit pkgs; };
        zig = import ./shells/zig.nix { inherit pkgs; };
        zed = import ./modules/zed { inherit pkgs; };
        vscode = import ./shells/vscode { inherit pkgs; };
        godot4 = godotModule.shell;
        godot = godotModule2.shell;
      };

      apps.${system} = {
        godot4 = godotModule.app;
        godot = godotModule2.app;
      };
    };
}

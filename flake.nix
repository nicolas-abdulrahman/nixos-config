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
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Bleeding edge
    sops-nix.url = "github:Mic92/sops-nix";
    
    continue = {
    url = "github:continuedev/continue";
    flake = false;
    };

	nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nvf, home-manager, nur, nixpkgs-unstable, nixgl, nixos-wsl, ... }:
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
          ./home/modules/nvim/nvf.nix ];
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


      godotModule = import ./devShells/godot4 { inherit pkgs pkgs-unstable; nixgl = nixgl.packages.${system}.nixGLIntel; nvim= myNvim; };
      godotModule2 = import ./devShells/godot { pkgs = pkgs-unstable; };
        modules = [
          ./home/home.nix
          ./modules/openhands
        ];
    in
    {
    
      homeConfigurations."nick_desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = { inherit inputs godotModule; nvim=nvfPkg; hyprland = inputs.hyprland;
          username = "nick";
          full = true;
          hypr = true;
          system = "desktop";
        };
      };
      homeConfigurations."nick_laptop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = { inherit inputs username godotModule; nvim=nvfPkg; hyprland = inputs.hyprland;
          user = "nick";
          full = false;
          hypr = false;
          system= "laptop";
        };
      };



  nixosConfigurations =  let
  mkHost = { hostname, users ? [] }: nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/common/configuration.nix
      ./hosts/${hostname}/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension= "bak";
        home-manager.extraSpecialArgs = { inherit inputs; };

        home-manager.sharedModules = [
          
          ./home/common/home.nix
          ./home/common/pkgs.nix
        ];
        home-manager.users = builtins.listToAttrs (map (user: {
          name = user;
          value = import ./home/users/${user}/home.nix;
        }) users);
      }
    ];
  };
in{
    desktop = mkHost { hostname = "desktop"; users = [ "nick" "nasr" "lfs" ]; };
    laptop  = mkHost { hostname = "laptop";  users = [ "nick" ]; };
    wsl     = mkHost { hostname = "wsl";     users = [ "nick" "nasr" ]; };
  };
    nixosConfigurationss = {
	      wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-wsl.nixosModules.default 
            ./hosts/common/configuration.nix
            ./hosts/wsl/configuration.nix         
          ];
	      };
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/common/configuration.nix
            ./hosts/desktop/configuration.nix
            ./hosts/common/desktop_manager.nix
        ];
        };
        laptop= nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/common/configuration.nix
            ./hosts/laptop/configuration.nix
            ./hosts/common/desktop_manager.nix
        ];
        };
      };

      packages.${system} = {
        nvim = nvfPkg;
        godot = godotModule.app;
      };

      devShells.${system} = {
        c = import ./devShells/c.nix { inherit pkgs; };
        java = import ./devShells/java.nix { inherit pkgs; };
        node = import ./devShells/node.nix { inherit pkgs; };
        python = import ./devShells/python.nix { inherit pkgs; };
        rust = import ./devShells/rust.nix { inherit pkgs; };
        wine = import ./devShells/wine.nix { inherit pkgs; };
        zig = import ./devShells/zig.nix { inherit pkgs; };
        zed = import ./modules/zed { inherit pkgs; };
        vscode = import ./devShells/vscode { inherit pkgs; };
        godot4 = godotModule.shell;
        godot = godotModule2.shell;
      };

      apps.${system} = {
        godot4 = godotModule.app;
        godot = godotModule2.app;
      };
    };
}

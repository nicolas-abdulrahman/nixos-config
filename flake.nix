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
          ./home/dotfiles/nvim/nvf.nix ];
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
    in
    {
    



  nixosConfigurations =  let
  mkHost = { hostname, users ? [], configuration ? {},  }: nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/common/configuration.nix
      ./hosts/${hostname}/configuration.nix

                  ({
        networking.hostName = hostname;
        hostUsers = users;
      } // configuration)
    ];
  };
in{
    desktop = mkHost {
      hostname = "desktop";
      users = [ "nick" "nasr" "lfs" ];
    };
    laptop = mkHost {
      hostname = "laptop";
      users = [  "stanley"];
    };
    wsl = mkHost {
      hostname = "wsl";
      users = [ "nasr" ];
    };
  };

      homeConfigurations = {
        nick = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            username = "nick";
            hypr = true;
            full = true;
            git = {
              name = "nicolas";
              email = "nicolas.abdul.rahman@gmail.com";
            };
          };
          modules = [
            ./home/home.nix
          ];
        };
        stanley = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            username = "stanley";
            hypr = false;
            full = false;
            git = {
              name = "stanley";
              email = "Stanleynz@gmail.com";
            };
          };
          modules = [
            ./home/home.nix
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

{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
  };

  outputs = { self, nixpkgs }:
    let


      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      RStudio-with-my-packages = pkgs.rstudioWrapper.override { packages = with pkgs.rPackages; [ ggplot2 dplyr xts ]; };
      kernels = pkgs.jupyter.kernels;
      irkernel = kernels.iRWith {
        name = "nixpkgs";
        # Libraries to be available to the kernel.                                
        packages = p: with p; [
          ggplot2
        ];
      };

      jupyterEnvironment = (pkgs.jupyter.override {
        kernels = [ irkernel ];
      });
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs;[
          # jupyterEnvironment
          # pkgs.config
          # jupyter.env.all
          jupyter-all

        ];
        # JUP = daJupyter;

      };

    };
}


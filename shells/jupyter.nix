{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
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
pkgs.mkShell {
  name = nameNoExt;
  packages = with pkgs;[
    # jupyterEnvironment
    # pkgs.config
    # jupyter.env.all
    jupyter-all

  ];
  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}

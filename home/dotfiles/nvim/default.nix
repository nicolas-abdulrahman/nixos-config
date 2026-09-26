{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = import ./nvf.nix { inherit pkgs; };
  };
}

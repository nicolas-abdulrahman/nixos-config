{ pkgs, ... }:

{
  # Install Google Antigravity from Nixpkgs
  home.packages = [
    pkgs.antigravity
    pkgs.antigravity-cli
  ];

}

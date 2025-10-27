{ pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = lib.readFile ./config.lua;
    package = pkgs.wezterm;
  };


}

{ pkgs, inputs, config, lib, ... }:
{
  environment.systemPackages = with pkgs;
    [git firefox gparted st fish zsh home-manager];
}

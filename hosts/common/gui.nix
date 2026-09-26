{ pkgs, inputs, config, lib, ... }:
{
  environment.systemPackages = with pkgs;
    [firefox gparted];
}

{ pkgs, inputs, config, lib, ... }:
{
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs;
    [firefox];
}

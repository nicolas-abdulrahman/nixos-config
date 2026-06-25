{ pkgs, lib, config, ... }:
{
  imports = [
    ./alacritty.nix
    ./tmux
    ./wezterm
    ./hyprland
    ./eww
     ./nixcord.nix
     ./godot
    #./xremap.nix
  ];
}

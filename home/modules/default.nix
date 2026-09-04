{ pkgs, lib, config, ... }:
{
  imports = [
    ./openhands
    ./alacritty.nix
    ./tmux
    ./wezterm
    ./hyprland
    ./eww
     ./godot
    ./firefox
    ./ai
    #./xremap.nix
  ];
}

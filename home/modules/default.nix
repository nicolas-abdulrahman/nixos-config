{ pkgs, lib, config, ... }:
let
  enable_hypr = config.hypr or false;
  enable_all = config.full or false;
in
{
  imports = [
    ./nvim/neovim.nix
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

{ pkgs, lib, hyprland, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
}

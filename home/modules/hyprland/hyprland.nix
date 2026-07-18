{ pkgs, lib, ... }:
let
  hyprsplitLua = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/shezdy/hyprsplit/6b00b677d8905fb38779c91e12d6294e0e586a44/init.lua";
    # First build: leave this as lib.fakeHash and run `home-manager switch`.
    # It will fail with a hash mismatch and print the correct hash — paste
    # that back in here and rebuild.
    hash = "sha256-31K47JQc1DJeMBR2VmOe+VpZfe0PC9uDcjddNs2K+P0=";
  };
in
{
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  xdg.configFile."hypr/hyprsplit/init.lua".source = hyprsplitLua;
}

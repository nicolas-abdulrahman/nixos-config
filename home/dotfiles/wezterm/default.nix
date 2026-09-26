{ pkgs, lib, config, ... }:
let
  livePath = "/etc/nixos/home/dotfiles/wezterm/config.lua";
in
{
  programs.wezterm.enable = true;

  xdg.configFile."wezterm/wezterm.lua".source =
    if builtins.pathExists livePath
    then config.lib.file.mkOutOfStoreSymlink livePath
    else ./config.lua;
}

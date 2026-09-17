{ pkgs, lib, config, ... }:
{
  xdg.configFile."wezterm/wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/modules/wezterm/config.lua";
}

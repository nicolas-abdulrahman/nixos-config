{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = pkgs.lib.readFile ./tmux.conf;
    plugins = with pkgs;[ ];
  };
}


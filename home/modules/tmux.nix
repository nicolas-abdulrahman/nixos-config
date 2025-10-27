{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = "";
    plugins = with pkgs;[ ];
  };
}


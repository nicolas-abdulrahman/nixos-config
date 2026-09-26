{ pkgs, hypr ? false, ... }:
{
  imports = [
    ./ai
    ./nvim
    ./tmux
    ./wezterm
    ./alacritty
    ./fish
    ./firefox
    ./i3
    ./kanata
    ./xdg
    ./zsh
  ] ++ (if hypr then [ ./hyprland ] else []);
}

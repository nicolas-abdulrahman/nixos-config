{ pkgs, hypr ? false, ... }:
{
  imports = [
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

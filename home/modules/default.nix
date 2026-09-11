{ pkgs, osConfig,... }:
{
  imports = [
    ./i3
    ./alacritty
    ./eww
    ./firefox
    ./fish
    ./kanata
    ./tmux
    ./wayscriber
    ./wezterm
    ./xdg
    ./zsh
    # ./godot << concept
    # ./xremap << should delete bruh
    # ./openhands << concept
    #./zed  << concept
  ]++ (if (osConfig.hypr or false) then [ ./hyprland ] else [])
    ++ (if (osConfig.ai or false) then [ ./ai] else []);

}





{ config, pkgs, inputs, lib, username, ... }:
{
home.packages = with pkgs; 
  # Essentials: Daily utilities, CLI tools, and networking
  [
    lazygit zoxide broot nnn kitty st brightnessctl pavucontrol aseprite
    warp-terminal git-credential-manager android-tools arp-scan nmap
  ] ++ 
  # Hyprland: Window manager specific tools
  (lib.optionals config.hypr [
    grimblast mako waybar eww hyprpaper hyprlock hypridle 
    wf-recorder hyprsunset swayimg
  ]) ++ 
  # Full: Heavy GUI apps, media, and office software
  (lib.optionals config.full [
    # Browsers & Media
    firefox floorp-bin google-chrome brave thunderbird spotify qbittorrent
    obs-studio audacity blender krita gimp
    
    # Utilities & Office
    wireshark metabase texliveFull prismlauncher protonup-qt 
    vesktop libreoffice-qt6 lutris waydroid steam-run steamcmd 
    gamescope weston blockbench equicord
  ]);
}

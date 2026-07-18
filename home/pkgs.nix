
{ config, pkgs, inputs, lib, username, nvim, ... }:
{
home.packages = with pkgs; 
  # Essentials: Daily utilities, CLI tools, and networking
  [
     
      nvim
    lazygit zoxide broot nnn kitty st brightnessctl pavucontrol aseprite
    warp-terminal git-credential-manager android-tools arp-scan nmap
  ] ++ 
  # Hyprland: Window manager specific tools
  (lib.optionals config.hypr [
    grimblast mako waybar eww hyprpaper hyprlock hypridle 
    wf-recorder hyprsunset swayimg xwayland 
  ]) ++ 
  # Full: Heavy GUI apps, media, and office software
  (lib.optionals config.full [
    # Browsers & Media
      gemini-cli aider-chat
    google-chrome brave thunderbird spotify qbittorrent
    obs-studio audacity blender krita gimp
    
    # Utilities & Office
    wireshark metabase texliveFull prismlauncher protonup-qt 
    libreoffice-qt6 lutris waydroid steam-run steamcmd 
    gamescope weston blockbench equicord steam
  ]);

    programs.vscode = lib.mkIf (config.full) {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        editorconfig.editorconfig
        dbaeumer.vscode-eslint
        stylelint.vscode-stylelint
        zainchen.json
      ];
    };
  programs.nixcord = {
    enable = true;

    # Choose your client (enable only one of these two)
     discord.vencord.enable = true; # Standard Vencord
   # discord.equicord.enable = true; # Equicord (has more plugins)
    vesktop.enable = true;
  };
}

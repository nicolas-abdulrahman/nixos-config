{ config, pkgs, inputs, lib, username, ... }: {
  home.packages = with pkgs; [
    nodejs_20
    nodePackages.tailwindcss
    ventoy

    equicord
    hyprsunset
    blockbench
    # ciscoPacketTracer8
    lazygit
    wf-recorder
    obs-studio
    flyctl
    gitkraken
    dbeaver-bin
    warp-terminal
    blender
    steamcmd
    audacity
    git-credential-manager
    pavucontrol
    tmux
    # vdhcoapp
    universal-ctags
    # Network
    arp-scan
    nmap
    kitty
    swayimg
    xorg.xrandr
    brightnessctl
    zoxide
    radare2
    openbox
    broot
    nnn
    steam-run
    firefox
    # discord
    lutris
    godot_4
    qbittorrent
    floorp-bin
    android-tools
    google-chrome
    brave
    st
  ] ++ (if config.hypr then [
    grimblast
    mako
    waybar
    eww
    hyprpaper
    hyprlock
    hypridle

    krita
  ] else [ ])
  # ++ (if config.laptop then [
  # st
  # ] else [
  # ])
  ++ (if config.full then [
    # jetbrains.idea-community-src
    smartgit
    # opera
    # okular
    weston
    gamescope
    protonup-qt
    vesktop
    gimp
    # notion
    blender
    krita
    waydroid
    wireshark
    metabase
    texliveFull
    prismlauncher
    # launcher
    # bobox.grapejuice
    thunderbird
    android-studio
    wireshark
    whatsie
    spotify
    waydroid
    libreoffice-qt6

  ] else [ ]);
}

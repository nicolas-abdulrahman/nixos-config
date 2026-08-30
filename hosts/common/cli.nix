{ pkgs,config, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;[]++  (lib.optionals (config.full) [
    alsa-lib
    glib
    libGL
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libXrender
    libxi
    libxkbcommon
    openssl
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    zlib
  ]);
  environment.systemPackages = with pkgs; [
    # --- MODERN REPLACEMENTS ---
    eza         # A modern replacement for 'ls' (colors, icons, tree view)
    bat         # A 'cat' clone with syntax highlighting and git integration
    fzf         # A command-line fuzzy finder (essential for speed)
    zoxide      # A smarter 'cd' command that learns your habits
    ripgrep     # 'rg' - Way faster than 'grep'
    fd          # A simple, fast replacement for 'find'
    tldr        # Simplified, example-based man pages

    # --- TERMINAL UI (TUI) APPS ---
    yazi        # Blazing fast terminal file manager (written in Rust)
    lazygit     # The best TUI for git (makes staging/committing visual)
    btop        # A beautiful system monitor (replaces htop/top)
    nvtopPackages.amd # GPU status monitor (works with WSL/Nvidia)

    # --- PRODUCTIVITY & UTILITIES ---
    ncdu        # Interactive disk usage analyzer
    unzip       # Standard utility for extracting zips
    gh          # GitHub CLI tool
    git
    
    # --- FUN / AESTHETICS ---
    fastfetch   # A faster, modern version of neofetch (system info)

    # Essentials
    home-manager pcmanfm  kanata
    cacert iproute2 inetutils nettools xremap tmux
    zsh git wget curl jq btop unzip file glib nix-index tree lsof st surf 

    #cool to have
    ffmpeg imagemagick 
    xorg.xorgserver xorg.xinit xorg.xrandr xorg.xsetroot xorg.xev
  ];

  # Some tools work better when enabled as "programs" 
  # because NixOS handles the shell integration automatically.
  programs.zoxide.enable = true;
  programs.fzf.keybindings = true;
  programs.starship.enable = true; # A very cool, fast, customizable shell prompt
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    btop        # A beautiful system monitor (replaces htop/top)
    nvtopPackages.amd # GPU status monitor (works with WSL/Nvidia)

    # --- PRODUCTIVITY & UTILITIES ---
    ncdu        # Interactive disk usage analyzer
    unzip       # Standard utility for extracting zips
    gh          # GitHub CLI tool
    git
    
    # --- FUN / AESTHETICS ---
    fastfetch   # A faster, modern version of neofetch (system info)

    # DEV
    uv

    # Essentials
    pcmanfm 
    cacert iproute2 inetutils nettools xremap tmux
    zsh wget curl jq file glib nix-index tree lsof st surf 

    # cool to have
    ffmpeg imagemagick 
    xinit xrandr xsetroot xev
  ];

  programs.starship.enable = true;
}

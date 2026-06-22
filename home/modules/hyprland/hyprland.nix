{ pkgs, lib, hyprland, ... }:

{
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {

    xwayland = {
      enabled = true;
    };
    input = {
      kb_layout = "us";
      follow_mouse = 2;
      sensitivity = 0;
    };
    general = {
      gaps_in = -200;
      gaps_out = 0;
      border_size = 2;
      layout = "master";
    };
    decoration = {
      inactive_opacity = 0.8;
      active_opacity = 1;
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      shadow = {
        enabled = true;
        range = 15;
        render_power = 3;
        color = "rgba(00000066)";
      };
    };
    animations = {
      enabled = true;
      bezier = "popOut, 0.13, 0.99, 0.29, 1.01";
      animation = "windows, 1, 4, popOut, slide";
    };
    misc = {
      enable_anr_dialog = false;
      force_default_wallpaper = 0;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };


    windowrule = [
      # 1. Main Godot Editor: Always launch in Fullscreen
      "match:class ^[Gg]odot$, match:title .*Godot Engine.*, fullscreen on"

      # 2. Game Preview: Send to second monitor and force maximize it
      # (Replace 'DP-2' with your exact monitor name from `hyprctl monitors`)
      "match:class ^[Gg]odot$, match:title .*DEBUG.*, monitor DP-1, maximize on"
    ];
    "$mod" = "SUPER";
    bind = [
      "$mod, A, fullscreen, 0"
      "$mod, Q, killactive"
      "$mod, E, exec, xdg-open ~"
      "$mod, Y, exec, wezterm"
      "$mod, G, exec, google-chrome-stable"
      "$mod, K, exec, krita"
      "$mod, I, exec, gimp"
      "$mod, T, exec, alacritty"
      "$mod, F, exec, firefox"
      "$mod, D, exec, equicord -- --enable-features=UseOzonePlatform --ozone-platform=wayland"
      "$mod, M, exec, prismlauncher"
      "$mod, B, exec, wezterm -e btop"
      "$mod, C, exec, pkill waybar"
      "$mod+CTRL, C, exec, waybar"
      ", Print, exec, grimblast copy area"
      "$mod+Shift, M, exit"
      "$mod, Q, killactive"
      "$mod, mouse:274, togglefloating,"
      "$mod, Tab, swapactiveworkspaces, current +1"
      "$mod, Tab, focusmonitor, +1"
    ]

    ++ (
      builtins.concatLists (builtins.genList
        (x:
          let
            keys = [ "left" "right" "up" "down" ];
            keys2 = [ "h" "l" "k" "j" ];
            dir = [ "l" "r" "u" "d" ];
            k = builtins.elemAt keys x;
            k2 = builtins.elemAt keys2 x;
            d = builtins.elemAt dir x;
          in
          [
            "$mod, ${k}, movefocus, ${d}"
            "$mod, ${k2}, movefocus, ${d}"
          ]
        ) 4)
    )
    # FIXED: Clean, single workspace loop for 1-10 (handles 0 key for workspace 10)
    ++ (
      builtins.concatLists (builtins.genList
        (x:
          let
            # If x is 9 (the 10th item), bind it to the "0" key, otherwise use x + 1
            key = if x == 9 then "0" else toString (x + 1);
            ws = toString (x + 1);
          in
          [
            "$mod, ${key}, workspace, ${ws}"
            "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
          ]
        ) 10)
    );
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    submap = not_on_term
    bind= Alt, 1, workspace, 1
    bind= Alt, 2, workspace, 2
    bind= Alt, 3, workspace, 3
    submap = reset
  '';
}

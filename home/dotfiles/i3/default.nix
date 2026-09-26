    { pkgs, lib, ... }:
    let
      mod = "Mod4"; # Super key
    in
    {
      xsession.windowManager.i3 = {
        enable = true;
        config = {
          modifier = mod;
          terminal = "${pkgs.st}/bin/st";

          # Cleaner modern look (removes bulky titlebars & adds gaps)
          window = {
            titlebar = false;
            border = 2;
          };
          floating.modifier = mod; # Hold Super + Left-click to drag, Right-click to resize!

          gaps = {
            inner = 8;
            outer = 4;
          };

          fonts = {
            names = [ "monospace" ];
            size = 10.0;
          };

          bars = [{
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }];

          # Dedicated Resize Mode (Press Super + r, then use h/j/k/l to resize, Enter/Esc to stop)
          modes = {
            resize = {
              "h" = "resize shrink width 10 px or 10 ppt";
              "j" = "resize grow height 10 px or 10 ppt";
              "k" = "resize shrink height 10 px or 10 ppt";
              "l" = "resize grow width 10 px or 10 ppt";
              "Left" = "resize shrink width 10 px or 10 ppt";
              "Down" = "resize grow height 10 px or 10 ppt";
              "Up" = "resize shrink height 10 px or 10 ppt";
              "Right" = "resize grow width 10 px or 10 ppt";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
          };

          keybindings = lib.mkOptionDefault {
            # --- App Launchers ---
            "${mod}+t" = "exec ${pkgs.st}/bin/st";
            "${mod}+f" = "exec ${pkgs.firefox}/bin/firefox";
            "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun"; # Fast App Launcher

            # --- Window Actions ---
            "${mod}+q" = "kill";                           # Close window directly
            "${mod}+Shift+space" = "floating toggle";      # Toggle floating window
            "${mod}+space" = "focus mode_toggle";          # Toggle focus between tiling/floating
            "${mod}+m" = "fullscreen toggle";              # Fullscreen toggle

            # --- Layouts & Splits ---
            "${mod}+b" = "split h";                        # Horizontal split
            "${mod}+v" = "split v";                        # Vertical split
            "${mod}+s" = "layout stacking";                # Stacking layout
            "${mod}+w" = "layout tabbed";                  # Tabbed layout
            "${mod}+e" = "layout toggle split";            # Toggle split layout

            # --- Vim Navigation (Focus) ---
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";

            # --- Move Windows (Vim keys) ---
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            # --- Workspaces (1 to 9) ---
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";

            # --- Resize Mode & System Controls ---
            "${mod}+r" = "mode resize";                    # Enter resize mode
            "${mod}+Shift+c" = "reload";                   # Reload i3 config without restart
            "${mod}+Shift+r" = "restart";                  # In-place restart i3 (0.1s!)
            "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -b 'Yes' 'i3-msg exit'";

            # --- Audio & Brightness (Fn keys) ---
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5";
            "XF86AudioMute"        = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -t";
            "XF86MonBrightnessUp"   = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
            "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
          };
        };
      };
    }

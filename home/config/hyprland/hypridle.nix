{ pkgs, lib, ... }:
let
  # Path to your config files (if needed)
  path = "/etc/nixos/users/sunshine/home";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 600;                # 10 minutes – you can dismiss without password during this time
        hide_cursor = true;
        no_fade_in = false;
        gaps_in = 10;
        gaps_out = 0;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''
            '<span foreground="##cad3f5">ٱلْحَمْدُ لِلَّٰهِ</span>'
          '';
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";      # This is the command to lock; we'll use it at 20 minutes
      };

      listener = [
        # 1. Show hyprlock after 20 minutes (1200s)
        {
          timeout = 1200;
          on-timeout = "hyprlock";
        }

        # 2. Turn screen off after 30 minutes (1800s)
        {
          timeout = 1800;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # 3. Suspend (sleep) after 1 hour (3600s)
        {
          timeout = 3600;
          on-timeout = "systemctl suspend";
          on-resume = "hyprctl dispatch dpms on";   # Re-enable screen after wake
        }

        # 4. Shut down after 3 hours (10800s)
        {
          timeout = 10800;
          on-timeout = "poweroff";
        }
      ];
    };
  };
}

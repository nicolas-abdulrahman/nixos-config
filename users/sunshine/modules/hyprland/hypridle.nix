{ pkgs, lib, ... }:
let path = "/etc/nixos/users/sunshine/home"; in
{

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 300;
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
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 200;
          on-timeout = "hyprlock";
        }
        {
          timeout = 3000;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 9000;
          on-timeout = "poweroff";

        }
      ];
    };
  };

}

{ pkgs, lib, ... }:
let
  # --- tune the timing here ---
  idleBeforeDim   = 600; # seconds idle before the screen starts fading out (10 min)
  dimSteps        = 20;  # brightness steps in the fade (also ~seconds, 1s per step)
  kbdOffDelay     = 10;  # seconds after the screen is fully off before killing kbd backlight
  idleBeforeSleep = 3600; # seconds idle before the machine suspends (1 h)

  # Gradually fades the screen to black over `dimSteps` seconds, then turns
  # the display off completely with DPMS.
  dim = pkgs.writeShellScriptBin "hypridle-dim" ''
    set -euo pipefail
    brightnessctl -s -q || true   # remember current brightness so we can restore it

    for ((i = ${toString dimSteps}; i >= 0; i--)); do
      pct=$(( i * 100 / ${toString dimSteps} ))
      brightnessctl set "''${pct}%" -q || true
      sleep 1
    done

    hyprctl dispatch dpms off
  '';

  # Undoes `dim`: kills any fade still in progress, wakes the display, restores brightness.
  restore = pkgs.writeShellScriptBin "hypridle-restore" ''
    set -euo pipefail
    pkill -f hypridle-dim >/dev/null 2>&1 || true
    hyprctl dispatch dpms on
    brightnessctl -r -q || brightnessctl set 100% -q
  '';

  # Turns off keyboard backlight if the hardware has one. Safe no-op if not.
  kbdOff = pkgs.writeShellScriptBin "hypridle-kbd-off" ''
    set -euo pipefail
    for dev in $(brightnessctl -l 2>/dev/null | grep -i "kbd_backlight" | sed -n "s/.*'\(.*\)'.*/\1/p"); do
      brightnessctl -d "$dev" set 0 -q || true
    done
  '';

  kbdOn = pkgs.writeShellScriptBin "hypridle-kbd-on" ''
    set -euo pipefail
    pkill -f hypridle-kbd-off >/dev/null 2>&1 || true
    for dev in $(brightnessctl -l 2>/dev/null | grep -i "kbd_backlight" | sed -n "s/.*'\(.*\)'.*/\1/p"); do
      brightnessctl -d "$dev" set 100% -q || true
    done
  '';
in
{
  # brightnessctl is required by the scripts above
  home.packages = [ pkgs.brightnessctl ];

  # NOTE: programs.hyprlock has been removed entirely, on purpose.

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        # no lock_cmd — there is no lock screen anymore
      };
      listener = [
        # 1. Screen fades gradually to black, ending with the display fully off
        {
          timeout = idleBeforeDim;
          on-timeout = "${dim}/bin/hypridle-dim";
          on-resume = "${restore}/bin/hypridle-restore";
        }
        # 2. Shortly after the screen is fully off, kill the keyboard backlight
        {
          timeout = idleBeforeDim + dimSteps + kbdOffDelay;
          on-timeout = "${kbdOff}/bin/hypridle-kbd-off";
          on-resume = "${kbdOn}/bin/hypridle-kbd-on";
        }
        # 3. Finally, suspend the machine
        {
          timeout = idleBeforeSleep;
          on-timeout = "systemctl suspend";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}


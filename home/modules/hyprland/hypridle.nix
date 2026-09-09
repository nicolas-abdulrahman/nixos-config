{ pkgs, lib, ... }:
let
  idleBeforeDim   = 1200; # 20 min: start fading
  dimSteps        = 60;   # ~60s fade duration
  idleBeforeSleep = 7200; # 2 h: suspend

  dim = pkgs.writeShellScriptBin "hypridle-dim" ''
    set -euo pipefail
    for ((i = ${toString dimSteps}; i >= 0; i--)); do
      pct=$(( i * 100 / ${toString dimSteps} ))
      brightnessctl set "''${pct}%" -q || true
      sleep 1
    done
    hyprctl dispatch dpms off
  '';

  restore = pkgs.writeShellScriptBin "hypridle-restore" ''
    set -euo pipefail
    pkill -f hypridle-dim || true
    hyprctl dispatch dpms on
    brightnessctl set 100% -q || true
  '';
in
{
  home.packages = [ pkgs.brightnessctl ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = idleBeforeDim;
          on-timeout = "${dim}/bin/hypridle-dim";
          on-resume = "${restore}/bin/hypridle-restore";
        }
        {
          timeout = idleBeforeSleep;
          on-timeout = "systemctl suspend";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

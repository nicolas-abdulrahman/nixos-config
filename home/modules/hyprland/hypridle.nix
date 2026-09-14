{ pkgs, lib, ... }:
let
  idleBeforeDim   = 1200; # 20 min: start fading
  dimSteps        = 60;   # ~60s fade duration
  idleBeforeSleep = 7200; # 2 h: suspend

  dim = pkgs.writeShellScriptBin "hypridle-dim" ''
    set -euo pipefail
    for ((i = ${toString dimSteps}; i >= 0; i--)); do
      pct=$(( i * 100 / ${toString dimSteps} ))
       ddcutil setvcp 10 ''${pct} || true
      sleep 1
    done
    hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
  '';

  restore = pkgs.writeShellScriptBin "hypridle-restore" ''
    set -euo pipefail
    pkill -f hypridle-dim || true
    hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
    ddcutil setvcp 10 100
  '';
in
{
  home.packages = [ pkgs.brightnessctl ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd =   ''
        hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
          '';
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
          on-resume = "";
        }
      ];
    };
  };
}

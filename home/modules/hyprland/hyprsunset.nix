{ pkgs, ... }:

{
  systemd.user.services.hyprsunset = {
    Unit.Description = "Hyprland sunset blue light filter";
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 2000";
      Restart = "no";
    };
    # No Install – the timer will start this service
  };

  systemd.user.timers.hyprsunset = {
    Unit.Description = "Timer to start hyprsunset at 17:30";
    Timer = {
      OnCalendar = "*-*-* 17:30:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.hyprsunset-stop = {
    Unit.Description = "Stop hyprsunset service";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user stop hyprsunset.service";
    };
  };

  systemd.user.timers.hyprsunset-stop = {
    Unit.Description = "Timer to stop hyprsunset at 06:00";
    Timer = {
      OnCalendar = "*-*-* 06:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

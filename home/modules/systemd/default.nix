{ config, pkgs, inputs, lib, ... }:
let path = "/etc/nixos/users/sunshine"; in
{
  systemd.user.services = {
    startup-service = {
      Unit = {
        Description = "set bg";
      };
      # Timer ={
      # OnStartupSec="10sec";
      # };
      Service = {
        Type = "oneshot";
        # TimeoutStartSec="10s";
        ExecStart = "${pkgs.writeShellScript "startup-service" ''
                    #!/run/current-system/sw/bin/bash
                     sleep 2
                    hyprctl hyprpaper wallpaper ", /etc/nixos/users/sunshine/home/walpaper7.jpg"
                    ''}";
      };
      Install = {
        WantedBy = [ "graphical-session.target" "default.target" ];
      }; # starts after login
    };
  };
  systemd.user.startServices = true;

}



{ pkgs,config, ... }:

{
     services.kanata = {
      enable = true;

      keyboards.default = {
        devices = [
      "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.3:1.1-event-kbd"
      "/dev/input/by-path/pci-0000:00:1a.0-usb-0:1.4:1.0-event-kbd"
    ];
        configFile=  ../conf/keys.kbd;
      };
    }; 
    systemd.services."kanata-default".wantedBy = [ "multi-user.target" ];
}

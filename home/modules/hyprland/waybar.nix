
{ pkgs, lib, ... }: 
{
    programs.waybar={
        enable = true;
        style = ''${lib.readFile ./waybar_style.css}'';
        settings.mainBar = 
{
    "layer"= "top"; 
    "position"= "top"; 
    height= 5; 
    # "modules-left"= ["sway/workspaces" "sway/mode" "custom/spotify"];
    # "modules-center"= ["sway/window"];
    "modules-right"= ["clock"];
    "sway/workspaces"= {
        "disable-scroll"= true;
        "all-outputs"= false;
        "format"= "{icon}";
        "format-icons"= {
            "1=web"= "";
            "2=code"= "";
            "3=term"= "";
            "4=work"= "";
            "5=music"= "";
            "6=docs"= "";
            "urgent"= "";
            "focused"= "";
            "default"= "";
        };
    };
    "tray"= {
        "spacing"= 10;
    };
    "clock"= {
        "format-alt"= "{:%Y-%m-%d}";
    };
    "cpu"= {
        "format"= "{usage}% ";
    };
    "memory"= {
        "format"= "{}% ";
    };
      "network"= {
        "interface"= "wlp2s0"; 
         "format-wifi"= "{essid} ({signalStrength}%) ";
        "format-ethernet"= "{ifname}: {ipaddr}/{cidr} ";
        "format-disconnected"= "Disconnected ⚠";
    };
    "pulseaudio"= {
        "format"= "{volume}% {icon}";
        "format-bluetooth"= "{volume}% {icon}";
        "format-muted"= "";
        "format-icons"= {
            "headphones"= "";
            "handsfree"= "";
            "headset"= "";
            "phone"= "";
            "portable"= "";
            "car"= "";
            "default"= ["" ""];
        };
        "on-click"= "pavucontrol";
    };
    };
};
}

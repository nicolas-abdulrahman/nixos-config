{ config, pkgs, ... }:

{
  # 1. Install Wayscriber
  home.packages = with pkgs; [
    wayscriber
  ];

  # 2. Configure the background daemon to start automatically
  systemd.user.services.wayscriber = {
    Unit = {
      Description = "Wayscriber Live Annotation Daemon";
      Documentation = "https://wayscriber.com/docs";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wayscriber}/bin/wayscriber";
      Restart = "on-failure";
      RestartSec = "2";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

xdg.configFile."wayscriber/config.toml".text = ''
    # Wayscriber configuration file managed by Home Manager

  [performance]
  enable_vsync = false
  max_fps_no_vsync = 120

  [keybindings]
  undo = ["z"]
  redo = ["x"]
  clear_canvas = ["c"]
  quit = ["v"]

  # Pen/Tool drag bindings or colors live under presets or drawing tools
  [drawing]
  default_color = "blue"
  default_size = 5
'';
}

{ pkgs, config, ... }:

let
  username = config.home.username;
  term = if username == "nasr" then "alacritty" else "wezterm";
  # Wrapper script to spawn Wezterm + Yazi for file picker dialogs
  yaziPicker = pkgs.writeShellScript "yazi-picker" ''
    out="$1"
    dir="$2"
    exec ${term} start -- yazi "$dir" --chooser-file="$out"
  '';
in
{
  home.packages = with pkgs; [
    imv
    yazi
    wezterm
    xdg-desktop-portal-termfilechooser
  ];

  # =========================================================================
  # 1. FILE PICKERS (Portals) - Intercepts Ctrl+O / Upload File popups
  # =========================================================================
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-termfilechooser
    ];
    config = {
      common = {
        default = [ "termfilechooser" ];
      };
      hyprland = {
        default = [ "hyprland" "termfilechooser" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
    };
  };

  # Config file telling termfilechooser to run your script
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [cmd]
    default=${yaziPicker} %1 %2 %3
  '';

  # =========================================================================
  # 2. DEFAULT APPS (MIME) - Controls clicking folders and opening files
  # =========================================================================
  xdg.desktopEntries.yazi-wezterm = {
    name = "Yazi (Wezterm)";
    exec = "${term} start -- yazi %u";
    icon = "yazi";
    terminal = false;
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "okular.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "vlc.desktop";
      "inode/directory" = "yazi-wezterm.desktop";
    };
  };
}

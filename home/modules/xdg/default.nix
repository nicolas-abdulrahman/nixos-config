{ pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "okular.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "video/mp4" = "vlc.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}

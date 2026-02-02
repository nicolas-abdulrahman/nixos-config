{ config, pkgs, ... }:

{

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";
  #services.xserver.xkb = {
  #  layout = "br";
  #  variant = "nodeadkeys";
  # };
  #console.keyMap = "br-abnt2";
  services.xserver.videoDrivers = [ "modsetting" "amdgpu" ];
  ########### DISPLAY & LOGIN MANAGER ###########
  services.displayManager.sddm.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;

  };

  # programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.hyprland.default = [ "hyprland" ];
  };

  ########### DESKTOP ENVIRONMENTS ###########
  # --- Plasma 6 (KDE) ---
  services.desktopManager.plasma6.enable = true;
  # --- XFCE ---
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  ########### WAYLAND COMPOSITOR ###########
  # Hyprland on Wayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };



  ########### OPTIONAL QUALITY OF LIFE ###########
  # Allows you to pick Plasma / XFCE / Hyprland at login
  services.displayManager.sddm.wayland.enable = true;

  # Enable polkit & PAM for session auth
  security.pam.services.sddm.enable = true;
  security.pam.services.login.enable = true;
  # security.pam.services.gdm.enable = true;

}

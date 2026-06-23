{ config, pkgs, inputs, useHypr, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ];
    desktopManager.xfce.enable = true;
    desktopManager.lxqt.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock ];
    };
  };

  console.keyMap = "us";

  programs.hyprland = if useHypr then {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  } else {
    enable = false;
  };

  services.displayManager = {
    sddm.enable = false;
    ly.enable = true;
  };

  security.pam.services.login.enable = true;
}

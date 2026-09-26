{ config, pkgs, inputs, lib, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ];
    desktopManager.xfce.enable = true;
    desktopManager.lxqt.enable = true;

    windowManager.i3 = {
      enable = true;
    };
  };

  console.keyMap = "us";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  services.displayManager = {
    sddm.enable = false;
    ly.enable = true;
  };

  security.pam.services.login.enable = true;
}

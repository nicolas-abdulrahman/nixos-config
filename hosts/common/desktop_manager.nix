{ config, pkgs, inputs, lib, ... }:

{
  services.xserver.enable = config.xserver;
  services.xserver = {
    xkb.layout = "us";
    videoDrivers = [ "amdgpu" ];
    desktopManager.xfce.enable = true;
    desktopManager.lxqt.enable = true;

    windowManager.i3 = {
      enable = true;
    };
  };

  console.keyMap = "us";

  programs.hyprland = if config.hypr then {
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

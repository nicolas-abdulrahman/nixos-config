{ config, pkgs, inputs, lib, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = if config.desktop then [ "amdgpu" ] else [ "modesetting" ];
    desktopManager.xfce.enable = true;
    #   desktopManager.lxqt.enable = true;

    windowManager.i3 = {
      enable = true;
    };
  };

  console.keyMap = "us";

  programs.hyprland = {
    enable = config.hypr;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  services.displayManager = {
    sddm.enable = false;
    ly.enable = true;
  };

  security.pam.services.login.enable = true;
}

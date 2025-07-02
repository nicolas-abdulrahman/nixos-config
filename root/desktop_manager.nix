{ pkgs, inputs, hyprland, lib, config, ... }:

{

  security.rtkit.enable = lib.mkForce false;
  security.pam.services.login.enableGnomeKeyring = lib.mkForce false;
  security.polkit.enable = lib.mkForce false;
  services.xserver.videoDrivers = [ "amdgpu" ];


  security.pam.services.login.enableKwallet = lib.mkForce false;
  services.xserver.enable = true;


  programs.hyprland = {
    # enable = config.full;
    enable = true;
    package = hyprland;
  };

  systemd.services = {
    "display-manager".wantedBy = lib.mkForce [ ];
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
}

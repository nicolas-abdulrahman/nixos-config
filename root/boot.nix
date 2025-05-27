{ config, lib, ... }:
{
  security.pam.services.login.enableKwallet = true;
  security.pam.services.login.enableGnomeKeyring = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
  # services.getty.autologinUser = "sunshine";


  boot.kernel.sysctl = { "vm.swappiness" = 50; };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    systemd-boot = {
      enable = false;
    };
    grub = {
      # enable = !config.full;
      enable = true;
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };
  #  boot.loader.systemd-boot.enable = true;
  #boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
}

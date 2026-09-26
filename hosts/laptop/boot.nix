{ config, lib, pkgs, ... }:
{
  boot = {
    kernel.sysctl = { "vm.swappiness" = 80; };
    supportedFilesystems = [ "ntfs" "exfat" ];

    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = false;
        efiSupport = true;
      };
    };
  };
}

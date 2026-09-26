{ config, lib, pkgs, ... }:
{
  boot = {
    kernel.sysctl = { "vm.swappiness" = 50; };
    supportedFilesystems = [ "ntfs" "exfat" ];

    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = false;
        efiSupport = true;

        extraEntries = ''
          menuentry 'My Void Linux' {
              insmod part_gpt
              insmod ext2
              search --no-floppy --fs-uuid --set=root 4d83555a-7fa2-489f-a226-a35e87f901da
              linux /boot/vmlinuz-6.12.11_1 root=UUID=4d83555a-7fa2-489f-a226-a35e87f901da rw
              initrd /boot/initramfs-6.12.11_1.img
          }
        '';
      };
    };
  };
}

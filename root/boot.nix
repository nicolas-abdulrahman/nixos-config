{ config, lib, pkgs, ... }:
let
  # Create a custom GRUB keymap that maps j/k to down/up
  myGrubKeymap = pkgs.runCommand "j-k-keymap.gkb"
    {
      nativeBuildInputs = [ pkgs.ckbcomp pkgs.grub2 ];
    } ''
    # 1. Generate a standard US layout
    # 2. Use sed to swap the keys (scan codes for j and k)
    ckbcomp us | sed \
      -e 's/keycode  36 = j J/keycode  36 = Down/g' \
      -e 's/keycode  37 = k K/keycode  37 = Up/g' \
      > layout.ckb
    
    # 3. Compile it into the binary format GRUB understands
    grub-mklayout -i layout.ckb -o $out
  '';
in
{
  boot = {
    kernel.sysctl = { "vm.swappiness" = 50; };
    supportedFilesystems = [ "ntfs" "exfat" ];

    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true; # Moved this to the correct level

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true; # Set to false since you have your manual entry now!
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

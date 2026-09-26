{ config, pkgs,lib, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # 2. Enable Flakes and the 'nix' command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # 4. Networking
  networking.hostName = lib.mkForce "nixos-wsl";

  networking.wireless.enable = lib.mkForce false;
  systemd.services.wpa_supplicant.enable =lib.mkForce false;
  
  # Ensure standard WSL network handling is used
  networking.useDHCP =lib.mkForce false;

  # 5. Environment / Shell
  # This makes sure Windows paths (like code.exe) work in your terminal
  wsl.interop.includePath = true;

}

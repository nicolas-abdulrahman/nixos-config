{ config, pkgs, inputs, nixgl, lib, ... }:
{
  hardware.i2c.enable = true;
  environment.systemPackages = [ pkgs.ddcutil ];

  nix.settings.trusted-users = [ "root" "nick" "nasr" ];

  users = {
    mutableUsers = false;
    groups.sysadmins = {};
    defaultUserShell = pkgs.zsh;

    users = {
      root.hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";

      lfs = lib.mkIf (builtins.elem "lfs" config.hostUsers) {
        isNormalUser = true;
        description = "binux from scratch";
        extraGroups = [ ];
        password = "";
      };

      nick = lib.mkIf (builtins.elem "nick" config.hostUsers) {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "i2c" "wireshark" "networkmanager" "wheel" "uinput" "input" "sysadmins" "docker" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
      };

      nasr = lib.mkIf (builtins.elem "nasr" config.hostUsers) {
        isNormalUser = true;
        description = "Nasrl Hakim Abdul Rahman";
        extraGroups = [ "i2c" "wireshark" "networkmanager" "wheel" "uinput" "input" "sysadmins" "docker" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
      };
    };
  };
}

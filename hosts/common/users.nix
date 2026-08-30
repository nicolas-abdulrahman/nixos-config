{ config, pkgs, inputs, nixgl, lib, ... }:
{
  nix.settings.trusted-users = [ "root" "nasr" "nick" ];
  users = {
    mutableUsers = false;
    groups = {
      sysadmins = {};
    };

    users = {
      root = {
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
      };
      lfs = {
        isNormalUser = true;
        description = "binux from scratch";
        extraGroups = [ ];
        password = "";
      };
      nick = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "wireshark" "networkmanager" "wheel" "uinput" "input" "sysadmins" "docker" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
      };
      nasr = {
        isNormalUser = true;
        description = "Nasrl Hakim Abdul Rahman";
        extraGroups = [ "wireshark" "networkmanager" "wheel" "uinput" "input" "sysadmins" "docker" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
      };


    };
  };
  users.defaultUserShell = pkgs.zsh;
}

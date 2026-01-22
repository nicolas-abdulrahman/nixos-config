{ config, pkgs, inputs, nixgl, lib, ... }:
{
  nix.settings.trusted-users = [ "root" "sunshine" "nick" ];
  users = {
    mutableUsers = false;
    extraGroups.vboxusers.members = [ "sunshine" ];
    groups = {
      wireshark.members = [ "sunshine" ];
      jupyter = lib.mkIf (config.full) {
        members = [ "sunshine" ];
      };
    };

    users = {
      root = {
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
        # hashedPassword = "$6$5arvbg2fMQVmGVqE$tCxUL/sUWXU.HgBgZVCV87ZH0JfkZcboHb7l1VovADWQQFaLvDPoIQ8KJcjQBIPz1oWFq39nfFvOgFjw5v58v";

      };
      susnhine = {
        isNormalUser = true;
        description = "happy sunshine";
        extraGroups = [ "docker" "wireshark" "networkmanager" "wheel" "uinput" "input" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
        # hashedPassword = "$6$5arvbg2fMQVmGVqE$tCxUL/sUWXU.HgBgZVCV87ZH0JfkZcboHb7l1VovADWQQFaLvDPoIQ8KJcjQBIPz1oWFq39nfFvOgFjw5v58v";
        group = "sunshine";
      };
      lfs = {
        isNormalUser = true;
        description = "binux from scratch";
        extraGroups = [ ];
        password = "";
      };
      nick = {
        isNormalUser = true;
        description = "Outnick";
        extraGroups = [ "wireshark" "networkmanager" "wheel" "uinput" "input" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
        # hashedPassword = "$6$5arvbg2fMQVmGVqE$tCxUL/sUWXU.HgBgZVCV87ZH0JfkZcboHb7l1VovADWQQFaLvDPoIQ8KJcjQBIPz1oWFq39nfFvOgFjw5v58v";
      };

    };
  };
  users.users.sunshine.isNormalUser = true;
  users.groups.sunshine = {};

  users.defaultUserShell = pkgs.zsh;

}

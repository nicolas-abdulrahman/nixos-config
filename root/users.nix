{ config, pkgs, inputs, nixgl, lib, ... }:
#let 
#    myjdk21 = pkgs.jdk21;
#in
{
  # users.users.wireshark.group = "wireshark";
  # users.users.wireshark = {           # isSystemUser= true;
  # group = "wireshark";
  # };
  users.groups.wireshark.members = [ "sunshine" ];
  users.groups.jupyter = lib.mkIf (config.full) {
    members = [ "sunshine" ];
  };
  users.mutableUsers = false;
  # users.users.jupyter.group = lib.optional (config.full) "jupyter";
  users.users.sunshine = {
    isNormalUser = true;
    description = "happy sunshine";
    extraGroups = [ "wireshark" "networkmanager" "wheel" "uinput" "input" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$BfDp8/sOWmP89sxNEqTlo0$sxkVAXNqeORIusCnJA.FCq/GQdvhx69u3z8i3Vxv2m4";
    # password = "banana";
    # users.users.your-user.initialHashedPassword = "banana";

  };


  users.defaultUserShell = pkgs.zsh;


  users.users.lfs = {
    isNormalUser = true;
    description = "binux from scratch";
    extraGroups = [ ];
    password = "";

  };

}

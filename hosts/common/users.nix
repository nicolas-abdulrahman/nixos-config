{ config, pkgs, inputs, nixgl, lib, ... }:

let
  userOpts = lib.types.submodule {
    options = {
      shell = lib.mkOption {
        type = lib.types.enum [ "zsh" "fish" "bash" ];
        default = "zsh";
      };
      terminal = lib.mkOption {
        type = lib.types.enum [ "wezterm" "alacritty" "kitty" "foot" "st" ];
        default = "wezterm";
      };
    };
  };
in
{
  # Declare custom options schema for user profiles
  options.userProfiles = lib.mkOption {
    type = lib.types.attrsOf userOpts;
    default = {};
  };

  config = {
    # Set the per-user preferences here

    hardware.i2c.enable = true;
    environment.systemPackages = [ pkgs.ddcutil ];

    nix.settings.trusted-users = [ "root" "nick" "nasr" ];

    # Ensure shells are built system-wide
    programs.zsh.enable = true;
    programs.fish.enable = true;

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
          shell = pkgs.fish;
          hashedPassword = "$6$1yVWgjhyIazvTqfo$IXmOS/7WNFmZawjFHKxkMRJV7ghHCfJ6iCrZPSp/DT5arY/K53llQwwh8VVrzQC0Kc0esQ86.bNFm/z/UHqst.";
        };
        stanley= lib.mkIf (builtins.elem "stanley" config.hostUsers) {
          isNormalUser = true;
          description = "Stanleynnnnn";
          extraGroups = [ "i2c" "wireshark" "networkmanager" "wheel" "uinput" "input" "sysadmins" "docker" ];
          shell = pkgs.fish;
          hashedPassword = "$6$t.2FnA1r9GLxmhKI$EVHw5xf3LNADuEP1yRog8kNRQzEGUtSyLtwF2aM6JsKDZPMfdg8lbA43Qhbvoj9Bl4iqA0yrOeCzo/vtd7Ggl1";
        };
      };
    };
  };
}


{ lib, pkgs, ... }:
with lib;
{
  enable = mkEnableOption "nix-zed: manage Zed editor config";

  package = mkOption {
    type = types.package;
    default = pkgs.zed-editor;
    description = "The Zed package to install.";
  };

  settings = mkOption {
    type = types.attrs;
    default = {};
    description = "Settings to be written to zed/settings.json.";
    example = {
      theme = "One Dark";
      vim_mode = true;
    };
  };

  keymaps = mkOption {
    type = types.listOf types.attrs;
    default = [];
    description = "Keymaps to be written to zed/keymap.json.";
  };
}

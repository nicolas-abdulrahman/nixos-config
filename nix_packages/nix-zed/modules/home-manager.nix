{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nix-zed;
  nix-zed-lib = import ../lib { inherit lib pkgs; };
in {
  options.programs.nix-zed = import ../options.nix { inherit lib pkgs; };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."zed/settings.json" = lib.mkIf (cfg.settings != {}) {
      text = builtins.toJSON cfg.settings;
    };

    xdg.configFile."zed/keymap.json" = lib.mkIf (cfg.keymaps != []) {
      text = builtins.toJSON cfg.keymaps;
    };
  };
}

{ pkgs, lib, config, ... }:
let
  enable_hypr = config.hypr or false;
  enable_all = config.full or false;

in
{
  imports = [
    ./nvim/neovim.nix
    ./alacritty.nix
    ./tmux
    ./wezterm
    #./xremap.nix
  ]
  ++ (lib.optionals true [
    ./hyprland
    ./eww
  ]
  );

  options = {
    enable_hypr = lib.mkEnableOption "Enable foo module";
  };
  # ++ (if config.full then [
  #   #
  #
  # ] else [ ]);
}

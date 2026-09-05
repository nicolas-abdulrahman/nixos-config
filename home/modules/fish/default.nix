{ config, lib, pkgs, ... }:

let
  # Define settings as a list and join them to avoid backslash/newline escaping issues
  tideConfig = lib.concatStringsSep " " [
    "--auto"
    "--style=Classic"
    "--prompt_colors='True color'"
    "--classic_prompt_color=Dark"
    "--show_time='12-hour format'"
    "--classic_prompt_separators=Angled"
    "--powerline_prompt_heads=Slanted"
    "--powerline_prompt_tails=Sharp"
    "--powerline_prompt_style='Two lines, character and frame'"
    "--prompt_connection=Dotted"
    "--powerline_right_prompt_frame=Yes"
    "--prompt_connection_andor_frame_color=Lightest"
    "--prompt_spacing=Compact"
    "--icons='Many icons'"
    "--transient=No"
  ];

  # Generate a unique hash of the configuration string at Nix evaluation time
  tideHash = builtins.hashString "sha256" tideConfig;
in
{
  programs.fish = {
    enable = true;

    # Include tide if you aren't already managing your plugins elsewhere
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    interactiveShellInit = ''
      # Idempotent tide configuration
      # Only runs the configuration if the Nix-generated hash has changed.
      if test "$tide_nix_config_hash" != "${tideHash}"
        tide configure ${tideConfig}
        set -U /* tide_nix_config_hash */ ${tideHash}
      end
    '';
  };
}

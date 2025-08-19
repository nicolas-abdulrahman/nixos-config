{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.eww;

  ewwConfigDir = pkgs.runCommand "eww-config"
    {
      yuck = cfg.yuck;
      scss = cfg.scss;
    } ''
    mkdir -p $out
    echo "$yuck" > $out/eww.yuck
    echo "$scss" > $out/eww.scss
  '';

  runScript = pkgs.writeShellScript "eww-run" ''
    echo "Starting eww daemon with config: ${ewwConfigDir}"
    # exec ${pkgs.eww}/bin/eww daemon --config ${ewwConfigDir}
    # echo "opening window"
    # exec ${pkgs.eww}/bin/eww open main-window --config ${ewwConfigDir}
    # exec ${pkgs.eww}/bin/eww close main-window --config ${ewwConfigDir}
  '';
  ewwPackage = pkgs.stdenv.mkDerivation {
    pname = "eww";
    version = "1.0";
    dontUnpack = true;
    # src = runScript;
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/eww <<EOF
      #!${pkgs.runtimeShell}
      echo "opening window"
      set -euo pipefail
      CONFIG="${ewwConfigDir}"
      if ! ${pkgs.procps}/bin/pgrep -x eww > /dev/null; then
        ${pkgs.eww}/bin/eww daemon --config "\$CONFIG" &
        sleep 0.5
      fi
      
      exec ${pkgs.eww}/bin/eww --config "\$CONFIG" "\$@"
      EOF

      chmod +x $out/bin/eww
    '';
    # buildCommand = ''
    #   mkdir -p $out/bin
    #   cp $src $out/bin/eww
    #   chmod +x $out/bin/eww
    # '';
  };
in
{
  options.eww = {
    enable = mkEnableOption "Enable Eww daemon runner";
    yuck = mkOption {
      type = types.str;
      default = ''
        (defwidget hello-widget []
          (label :text "Hello, Eww!"))
        (defwindow main-window
          :stacking "fg"
          :monitor 0
          :exclusive true
          :anchor "top center"
          :visible true
          (hello-widget))
      '';
      description = "Contents of eww.yuck";
    };
    scss = mkOption {
      type = types.str;
      default = "";
      description = "Contents of eww.scss";
    };

    run = mkOption {
      type = types.package;
      readOnly = true;
      description = "Shell script to run eww daemon with provided config";
    };
  };

  config = mkIf cfg.enable {
    eww.run = ewwPackage;

  };
}


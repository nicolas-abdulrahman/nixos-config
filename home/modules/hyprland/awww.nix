{ pkgs, lib, ... }:
let
  # Drop as many images as you want into ./wallpaper — the rotation script
  # picks them up automatically. Right now it'll just show the same image
  # on both monitors until you add more.
  wallpaperDir = ./wallpaper;

  # --- tune here ---
  monitors        = [ "HDMI-A-1" "DVI-D-1" ]; # must match `hyprctl monitors` names
  rotateInterval  = "10min";
  transitionType  = "any";

  # NOTE: pkgs.swww now builds the "awww" project (swww was renamed
  # upstream to "An Answer to your Wayland Wallpaper Woes" in Oct 2025
  # and moved to Codeberg). The nixpkgs attribute is still called `swww`
  # for compat, but the binaries inside are `awww` / `awww-daemon`.
  awww = pkgs.swww;

  # Picks a different image per monitor and advances on every run.
  # State (current index) persists in ~/.cache so rotation continues
  # sensibly across reboots instead of always restarting at image 0.
  rotateScript = pkgs.writeShellScript "awww-rotate" ''
    set -euo pipefail

    WALLDIR="${wallpaperDir}"
    STATE="$HOME/.cache/awww-rotate-index"
    mkdir -p "$(dirname "$STATE")"

    # wait up to ~5s for the daemon's IPC socket to appear
    for i in $(seq 1 50); do
      if ${awww}/bin/awww query >/dev/null 2>&1; then
        break
      fi
      sleep 0.1
    done

    mapfile -t files < <(find "$WALLDIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort)
    count="''${#files[@]}"
    if [ "$count" -eq 0 ]; then
      echo "no wallpapers found in $WALLDIR" >&2
      exit 1
    fi

    idx=0
    [ -f "$STATE" ] && idx=$(cat "$STATE")
    idx=$(( (idx + 1) % count ))
    echo "$idx" > "$STATE"

    ${lib.concatImapStringsSep "\n" (i: mon: ''
      offset=$(( (idx + ${toString (i - 1)}) % count ))
      img="''${files[$offset]}"
      ${awww}/bin/awww img -o "${mon}" "$img" --transition-type ${transitionType}
    '') monitors}
  '';
in
{
  home.packages = [ awww ];

  # 1. The daemon itself.
  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "awww wallpaper daemon (formerly swww)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${awww}/bin/awww-daemon";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # 2. Oneshot rotation job — sets a different wallpaper per monitor and
  # advances the rotation index. Triggered on session start and then
  # repeatedly by the timer below.
  systemd.user.services.awww-rotate = {
    Unit = {
      Description = "Rotate per-monitor wallpapers via awww";
      After = [ "awww-daemon.service" ];
      Requires = [ "awww-daemon.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${rotateScript}";
    };
  };

  # 3. Timer: fires shortly after login, then every `rotateInterval`.
  systemd.user.timers.awww-rotate = {
    Unit = {
      Description = "Timer for periodic wallpaper rotation";
      PartOf = [ "graphical-session.target" ];
    };
    Timer = {
      OnStartupSec = "15s";
      OnUnitActiveSec = rotateInterval;
      Unit = "awww-rotate.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}


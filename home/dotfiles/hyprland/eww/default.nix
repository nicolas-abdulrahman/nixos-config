{ pkgs, lib, ... }:
let
  ewwPkg = pkgs.eww;

  # Scans standard .desktop dirs, filters by the typed query, and prints a
  # ready-to-render yuck (box ...) literal string containing one clickable
  # (button) result per match. Exec commands are base64-encoded before being
  # embedded in the onclick string so we never have to worry about quoting
  # weird characters from arbitrary Exec= lines.
  searchApps = pkgs.writeShellScriptBin "eww-search-apps" ''
    #!/usr/bin/env bash
    query="$1"
    dirs="/run/current-system/sw/share/applications $HOME/.nix-profile/share/applications $HOME/.local/share/applications"

    declare -A seen
    out="(box :class \"results\" :orientation \"v\" :space-evenly false"
    count=0
    limit=8

    while IFS= read -r f; do
      [ -e "$f" ] || continue
      grep -q '^NoDisplay=true' "$f" 2>/dev/null && continue
      name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
      execraw=$(grep -m1 '^Exec=' "$f" | cut -d= -f2-)
      [ -z "$name" ] && continue
      [ -z "$execraw" ] && continue
      key="$name"
      [ -n "''${seen[$key]:-}" ] && continue
      seen[$key]=1

      if [ -n "$query" ]; then
        echo "$name" | grep -qi -- "$query" || continue
      fi

      [ "$count" -ge "$limit" ] && break
      count=$((count+1))

      execclean=$(echo "$execraw" | sed -E 's/%[a-zA-Z]//g')
      esc_name=$(printf '%s' "$name" | sed 's/\\/\\\\/g; s/"/\\"/g')
      b64=$(printf '%s' "$execclean" | base64 -w0)

      out="$out (button :class \"result\" :onclick \"${launchAppBin} $b64\" (label :class \"result-label\" :text \"$esc_name\" :halign \"start\"))"
    done < <(find $dirs -maxdepth 1 -name '*.desktop' 2>/dev/null | sort)

    out="$out)"

    if [ "$count" -eq 0 ]; then
      out="(box :class \"results\" :orientation \"v\" (label :class \"no-results\" :text \"No matches\"))"
    fi

    printf '%s' "$out"
  '';

  # Decodes the base64 exec string, launches it detached from eww's process
  # tree, then clears the search bar and closes the window.
  launchApp = pkgs.writeShellScriptBin "eww-launch-app" ''
    #!/usr/bin/env bash
    cmd=$(printf '%s' "$1" | base64 -d)
    setsid -f bash -c "$cmd" >/dev/null 2>&1 &
    disown
    ${ewwPkg}/bin/eww update search=""
    ${ewwPkg}/bin/eww update matches="(box)"
    ${ewwPkg}/bin/eww close searchbar 2>/dev/null || true
  '';

  launchAppBin = "${launchApp}/bin/eww-launch-app";

  # Fired on every keystroke in the input widget: re-runs the search and
  # pushes the freshly built result list into the `matches` eww var.
  onSearch = pkgs.writeShellScriptBin "eww-onsearch" ''
    #!/usr/bin/env bash
    text="$1"
    result=$(${searchApps}/bin/eww-search-apps "$text")
    ${ewwPkg}/bin/eww update matches="$result"
  '';

  ewwYuck = ''
    (defvar search "")
    (defvar matches "(box)")

    (defwindow searchbar
      :monitor "DVI-D-1"
      :geometry (geometry :x "0" :y "0" :width "560px" :height "420px" :anchor "top center")
      :stacking "overlay"
      :exclusive false
      :focusable true
      :windowtype "dialog"
      (searchbar-widget))

    (defwidget searchbar-widget []
      (box :class "searchbar" :orientation "v" :space-evenly false
        (box :class "search-row" :orientation "h" :space-evenly false :spacing 10
          (label :class "search-icon" :text "search")
          (input :class "search-input"
                 :value search
                 :onchange "${onSearch}/bin/eww-onsearch {}"
                 :timeout "10000ms"))
        (literal :content matches)))
  '';

  ewwScss = ''
    * {
      all: unset;
      font-family: "JetBrainsMono Nerd Font", "monospace";
    }

    .searchbar {
      background-color: rgba(20, 20, 28, 0.92);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 16px;
      padding: 14px;
      box-shadow: 0 12px 30px rgba(0, 0, 0, 0.45);
    }

    .search-row {
      padding: 6px 10px;
      background-color: rgba(255, 255, 255, 0.06);
      border-radius: 10px;
      margin-bottom: 8px;
    }

    .search-icon {
      color: rgba(255, 255, 255, 0.4);
      font-size: 13px;
      margin-right: 6px;
    }

    .search-input {
      color: #f2f2f2;
      font-size: 16px;
      min-width: 460px;
    }

    .results {
      padding-top: 4px;
    }

    .result {
      padding: 8px 10px;
      border-radius: 8px;
      margin-bottom: 2px;
    }

    .result:hover {
      background-color: rgba(120, 160, 255, 0.18);
    }

    .result-label {
      color: #e8e8e8;
      font-size: 14px;
    }

    .no-results {
      color: rgba(255, 255, 255, 0.35);
      font-size: 13px;
      padding: 10px;
    }
  '';

in
{
  home.packages = [ ewwPkg searchApps launchApp onSearch ];

  # NOTE: home-manager's `programs.eww` module only installs the package and
  # writes these files into ~/.config/eww — it does not start the daemon for
  # you, so we run `eww daemon` via a systemd user service instead, same
  # pattern as the awww setup. `configDir` is deprecated as of recent
  # home-manager in favour of yuckConfig/scssConfig (plain string content).
  programs.eww = {
    enable = true;
    package = ewwPkg;
    yuckConfig = ewwYuck;
    scssConfig = ewwScss;
  };

  systemd.user.services.eww-daemon = {
    Unit = {
      Description = "eww widget daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${ewwPkg}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}


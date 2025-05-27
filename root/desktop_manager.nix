{ pkgs, inputs, hyprland, lib, config, ... }:

{

  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;

  # services.xserver.desktopManager.plasma6.enable = config.full;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.plasma6Packages.ksshaskpass.out}/bin/ksshaskpass";
  # systemd.services."getty@tty1".enable = true;
  # systemd.services."autovt@tty1".enable = true;
  programs.hyprland = {
    # enable = config.full;
    enable = true;
    package = hyprland;
  };


  environment.etc = {
    "profile.local".text = ''
      # /etc/profile.local: DO NOT EDIT -- this file has been generated automatically.
      if [ -f "$HOME/.profile" ]; then
        . "$HOME/.profile"
      fi
      # exec i3
      # if [ -z "$DISPLAY" ] && [ $TTY == "/dev/tty1" ]; then
        # exec startx
      # fi
    '';
  };
  services.xserver = {
    videoDrivers = [ "modesetting" ];

    enable = false;
    autorun = false;
    windowManager.i3.enable = false;

    resolutions = [
      { x = 1280; y = 720; }
      { x = 1920; y = 1080; }
      { x = 2560; y = 1440; }
    ];

    # Enable touchpad support.
    # libinput.enable = true;

    desktopManager.gnome.enable = true;

    # Disable desktop manager.
    displayManager = {
      startx.enable = true;
      defaultSession = "none+i3";
      # autoLogin = {
      # enable = true;
      # user = "sunshine";
      # };

    };

  };

  systemd.targets = {
    "autologin-tty1" = {
      requires = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      unitConfig.AllowIsolate = "yes";
    };
  };

  # systemd.services = {
  #   "autovt@tty1" = {
  #     enable = true;
  #     restartIfChanged = false;
  #     description = "autologin service at tty1";
  #     after = [ "suppress-kernel-logging.service" ];
  #     wantedBy = [ "autologin-tty1.target" ];
  #     serviceConfig = {
  #       ExecStart = builtins.concatStringsSep " " ([
  #         "@${pkgs.utillinux}/sbin/agetty"
  #         "agetty --login-program ${pkgs.shadow}/bin/login"
  #         "--autologin user --noclear %I $TERM"
  #       ]);
  #       Restart = "always";
  #       Type = "idle";
  #     };
  #   };
  #   "suppress-kernel-logging" = {
  #     enable = true;
  #     restartIfChanged = false;
  #     description = "suppress kernel logging to the console";
  #     after = [ "multi-user.target" ];
  #     wantedBy = [ "autologin-tty1.target" ];
  #     serviceConfig = {
  #       ExecStart = "${pkgs.utillinux}/sbin/dmesg -n 1";
  #       Type = "oneshot";
  #     };
  #   };
  # };
  # Also avoid enabling any display manager. I think one of them is enabled by default, but oh well...
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.xdm.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # Enable the XFCE desktop environment
  # services.xserver.desktopManager.xfce.enable = true;

  # Optional: Use LightDM as the display manager
  # services.xserver.displayManager.lightdm.enable = true;
}

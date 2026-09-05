{ pkgs, ... }:

let
  # Generate the raw Kanata .kbd configuration file
  kanataConfig = pkgs.writeText "kanata-user.kbd" ''
    (defcfg
      danger-enable-cmd yes
      process-unmapped-keys yes
      linux-dev /dev/input/by-interface/uinput-kanata-internal-system-core
    )

    (defsrc
      caps a s d w q e f g h j k l u i o ralt c y n m p z x v b
    )

    (defalias
      simple_face (macro (unicode •) (unicode -) (unicode •))
      copy_cute   (cmd "bash -c \"echo -n '(๑ᵔ⤙ᵔ๑)' | wl-copy\"")
      cute_face   (macro @copy_cute (pause 40) lctl v)
    )

    (deflayer base
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    )

    (deflayer alt-r-hold
      _ _ _ _ @simple_face _ _ _ _ _ _ _ _ _ _ _ _ @cute_face (unicode ♡) _ _ _ _ _ _ _
    )
  '';
in
{
  # Ensure the cmd-enabled binary is available
  home.packages = [ pkgs.kanata-with-cmd ];

  # Create the user-level systemd service
  systemd.user.services.kanata-user = {
    Unit = {
      Description = "User-level Kanata with cmd enabled";
      # Ensures this only starts AFTER the display manager logs you into Wayland/X11
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      # Execute the Kanata binary with the generated configuration
      ExecStart = "${pkgs.kanata-with-cmd}/bin/kanata --cmd -c ${kanataConfig}";
      
      # Inject PATH so the background service can find bash and wl-copy
      Environment = "PATH=/run/current-system/sw/bin:${pkgs.bash}/bin:${pkgs.wl-clipboard}/bin";
      
      Restart = "always";
      RestartSec = 3;
    };
  };
}

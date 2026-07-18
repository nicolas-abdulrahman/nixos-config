{pkgs,...}:
{
  services.kanata = {
    enable = true;
    package = pkgs.kanata-with-cmd; # Compiled with cmd enabled

    keyboards.user-macros = {
      # CRITICAL: Intercept the virtual output of your base system configuration, 
      # NOT the raw physical platform path device.
      devices = [ "/dev/input/by-interface/uinput-kanata-internal-system-core" ];
      
      extraDefCfg = ''
        danger-enable-cmd yes
        process-unmapped-keys yes
      '';
      
      config = ''
        (defsrc
          caps a s d w q e f g h j k l u i o ralt c y n m p z x v b
        )

        (defalias
          simple_face (macro (unicode •) (unicode -) (unicode •))
          copy_cute   (cmd "bash -c \"echo -n '(๑ᵔ⤙ᵔ๑)' | wl-copy\"")
          cute_face   (macro @copy_cute (pause 40) lctl v)
        )

        ;; Fall through completely except for your alt-r macros
        (deflayer base
          _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
        )

        (deflayer alt-r-hold
          _ _ _ _ @simple_face _ _ _ _ _ _ _ _ _ _ _ _ @cute_face (unicode ♡) _ _ _ _ _ _ _
        )
      '';
    };
  };

# Ensure your user has proper group permissions to read uinput in their home configuration
  home.extraGroups = [ "input" "uinput" ];
}

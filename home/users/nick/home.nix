
{...}:{
  programs.zsh = {
    enable = true;
    initExtra = ''
      h() {
        local user=$1
        # Automatically grab the current system hostname (desktop, laptop, wsl, etc.)
        local host=$(hostname)
        
        # NOTE: Change this to the absolute path of your flake (e.g., ~/nixos or ~/.dotfiles) 
        # so you can run 'h nick' from any folder.
        local flakepath="."

        if [ -z "$user" ]; then
          echo "Usage: h <username>"
          return 1
        fi

        echo "🚀 Building Home Manager for '$user' on '$host'..."
        
        # Build the activation package
        nix build "$flakepath#nixosConfigurations.$host.config.home-manager.users.$user.home.activationPackage"
        
        # If the build succeeds, run the activator
        if [ $? -eq 0 ]; then
          echo "✨ Activating..."
          ./result/activate
        else
          echo "❌ Build failed."
        fi
      }
    '';
  };
    programs.git = {
      userName = "Nick";
      userEmail = "nicolashugo2001@gmail.com";
    };
}

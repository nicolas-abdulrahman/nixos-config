{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
  };

  # Symlink tmux config
  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
}

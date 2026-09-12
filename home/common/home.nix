



{ config,inputs, pkgs,... }:
let

  nixos_path = "/etc/nixos";
  browser = "firefox";
  fileExplorer = "pcmanfm";
  terminal = "st";

  sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
in

{
  imports = [
    inputs.nvf.homeManagerModules.default
    ../modules
  ];


  manual.manpages.enable = false;
manual.html.enable = false;
manual.json.enable = false;
  programs.nvf = {

  enable  = true;
  settings = import ../modules/nvim/nvf.nix { inherit pkgs; };
  };
  home.stateVersion = "26.05";

xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    application/pdf=okular.desktop   # you can change this
    text/html=${browser}.desktop
    x-scheme-handler/http=${browser}.desktop
    x-scheme-handler/https=${browser}.desktop
    x-scheme-handler/about=${browser}.desktop
    x-scheme-handler/unknown=${browser}.desktop
    inode/directory=${fileExplorer}.desktop
  '';

    home.sessionVariables = sessionVariables;
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };

  programs.starship = {
    enable = true;           # keep this — still gives you starship in zsh
    enableFishIntegration = false;   # stops starship from touching fish at all
  };
  programs.fzf = {
  enable = true;
  enableFishIntegration = true; # Enabled automatically when keybindings = true
};


  programs.git = {
  enable = true;
  
  settings = {
    credential = {
      helper = [
        "cache --timeout=3600"
        "${pkgs.git-credential-oauth}/bin/git-credential-oauth"
      ];
    };
  };
    includes = [
    {
      condition = "gitdir:/programs/codes/facul/";
      contents = {
        user = {
          name = "nicolas";
          email = "1352622646@ulife.com.br";
        };
      };
    }
  ];
};



}

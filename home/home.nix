{ config, pkgs, inputs, lib, username ? "nick", hypr ? false, full ? false, git ? { name = "nicolas"; email = "nicolas.abdul.rahman@gmail.com"; }, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  imports = [

    ./common/cli.nix
    ./common/pkgs.nix
    ./common/shell.nix
    ./dotfiles
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = git.name;
      user.email = git.email;
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "secretservice";
      };
      safe = {
        directory = [
          "/etc/nixos"
          "/programs/codes"
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

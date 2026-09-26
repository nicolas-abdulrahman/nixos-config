{ config, ... }: {
  # Point to Nick's specific age key and secrets file
  sops.age.keyFile = "/home/nick/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets/nick.yaml;
  
  # Define the secret
  sops.secrets.github_token = { };

  # Export it in the shell configuration by reading the file path
  programs.bash.initExtra = ''
    export GITHUB_TOKEN="$(cat ${config.sops.secrets.github_token.path})"
  '';
  
  # If you use Fish instead of Bash:
  programs.fish.interactiveShellInit = ''
    set -gx GITHUB_TOKEN (cat ${config.sops.secrets.github_token.path})
  '';
}

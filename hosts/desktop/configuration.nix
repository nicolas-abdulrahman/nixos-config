{...}:
{
    imports = [
      ./hardware-configuration.nix
      ./boot.nix
    ];
    docker = true;
    hypr = true;
    services.envfs.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
}

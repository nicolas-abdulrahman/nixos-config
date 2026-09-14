{...}:
{
    imports = [
      ./hardware-configuration.nix
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

{...}:
{
    imports = [
      ./hardware-configuration.nix
    ];
    docker = true;
    services.envfs.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
}

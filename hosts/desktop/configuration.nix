{...}:
{
    imports = [
      ./hardware-configuration.nix
      ./boot.nix
    ];
    desktop = true;
    docker = true;
    services.envfs.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
}

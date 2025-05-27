{ config, pkgs, inputs, nixgl, ... }:
#let 
#    myjdk21 = pkgs.jdk21;
#in
{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 3000 3001 3308 3307 3306 ];
  networking.firewall.allowedUDPPorts = [ 80 3000 3001 3308 3307 3306 ];
  networking.firewall.enable = true;
}

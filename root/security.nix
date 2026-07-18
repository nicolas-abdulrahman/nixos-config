{ config, pkgs, inputs, nixgl, ... }:
let
  keyFile = "/var/lib/sops-age/keys.txt";
in
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

  security.pki.certificateFiles = [ 
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" 
  ];
  environment.systemPackages = with pkgs;[ firejail age sops ];
    environment.variables = {
    SOPS_AGE_KEY_FILE =  keyFile;
  };

  # 2. Point sops to the path variable
  sops = {
  # 1. Age key setup
  age.keyFile = keyFile; 
  age.generateKey = true;

  # 2. Global file defaults
  defaultSopsFile = ./conf/secrets.yaml;
  defaultSopsFormat = "yaml";
  
  # /run/secrets/gemini_api_key
  secrets = {
    gemini_api_key_nasr = {
      owner = "root";
      group = "sysadmins";
      mode = "0440";
    };

    gemini_api_key = {
      owner = "root";
      group = "sysadmins";
      mode = "0440";
    };
    ghp_nasr = {
      owner = "root";
      group = "sysadmins";
      mode = "0440";
        };
  };
};
}

{ pkgs, lib, inputs, ... }:

{

  # Install Google Antigravity from Nixpkgs
  home.packages = [
    (pkgs.antigravity-cli.overrideAttrs (oldAttrs: rec {
      version = "1.1.27";

      src = pkgs.fetchurl {
        url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_${
          if pkgs.stdenv.isAarch64 then "arm64" else "x64"
        }.tar.gz";
        hash = "sha256-+HTU9rinPC32YPWA8l+2Vvy25krb/XRuZpLoN/2aIL4=";
      };
    }))
  ];
}

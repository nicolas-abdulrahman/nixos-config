{ nixpkgs ? null, lib ? if nixpkgs != null then nixpkgs.lib else (import <nixpkgs> {}).lib, pkgs ? if nixpkgs != null then nixpkgs.legacyPackages.x86_64-linux else import <nixpkgs> {}, ... }:

rec {
  # ---------------------------------------------------------------------------
  # extensionListToAttrs
  # ---------------------------------------------------------------------------
  extensionListToAttrs = ids:
    lib.listToAttrs (map (id: lib.nameValuePair id true) ids);

  # ---------------------------------------------------------------------------
  # buildLspConfig
  # ---------------------------------------------------------------------------
  buildLspConfig = lspAttrs:
    lib.mapAttrs
      (_name: lspCfg:
        lib.optionalAttrs (lspCfg.binary != null)
          {
            binary.path = toString lspCfg.binary;
          }
        // lib.optionalAttrs (lspCfg.settings != { }) {
          initialization_options = lspCfg.settings;
        }
      )
      lspAttrs;

  # ---------------------------------------------------------------------------
  # recursiveMerge
  # ---------------------------------------------------------------------------
  recursiveMerge = lib.foldl' lib.recursiveUpdate { };
}

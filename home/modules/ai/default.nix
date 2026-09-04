{ config, pkgs, lib, ... }:

let

   opencode-baseline = pkgs.stdenv.mkDerivation rec {
    pname = "opencode-baseline";
    version = "v1.18.3"; # Update to the current version if needed
    
    src = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/${version}/opencode-linux-x64-baseline.tar.gz";
      # Nix will complain about this fake hash on the first run. 
      # Copy the correct hash from the error message and paste it here!
      hash = "sha256:949e2ab72af9fd2d2037957e590c78f5d657cf87683a0f7cf3156358af0a8ebc";
    };

    # autoPatchelfHook is crucial on NixOS to link precompiled binaries to glibc
    nativeBuildInputs = [ pkgs.unzip pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp opencode $out/bin/opencode
      chmod +x $out/bin/opencode
    '';
  };
  # This cleanly evaluates to an absolute home path (e.g., /home/user/programs/models)
  modelDir = "/programs/models";
in
{
   programs.opencode = {
      enable = true;
      package = opencode-baseline; 

      
      settings = {
        
        # --- OPTION A: Local Model via Ollama ---
        model = "gemini/gemma-4-31b-it";
        autoupdate = false;
        autoshare = false; 
      };
      tui = {
        theme = "tokyonight"; # Optional: sets a nice dark theme
      };
  };
  # 1. Enable Ollama service
  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_MODELS = modelDir;
    };
  };
  home.file.".continue/config.json".text = builtins.toJSON {
  models = [
    {
      title = "DeepSeek Coder 1.3B";
      provider = "ollama";
      model = "deepseek-coder:1.3b";
      apiBase = "http://localhost:11434";
    }
  ];
  tabAutocompleteModel = {
    title = "DeepSeek Coder 1.3B";
    provider = "ollama";
    model = "deepseek-coder:1.3b";
    apiBase = "http://localhost:11434";
  };
  # Disables telemetry reporting
  allowAnonymousTelemetry = false;
};
}

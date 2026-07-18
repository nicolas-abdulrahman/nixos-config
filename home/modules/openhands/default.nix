{ config, pkgs, ... }:
{
    programs.openhands = {
    enable = true;
    workspaceDir = "/programs/code/";
    
    llm = {
      model = "gemini/gemini-3.1-flash-lite";
      apiKey = "GEMINI_API_KEY_NASR"; 
    };

    # This text will be written to /nix/store/...-openhands-config.toml 
    # and mounted directly into the sandbox.
    configText = builtins.readFile ./openhands.toml;
  };
}

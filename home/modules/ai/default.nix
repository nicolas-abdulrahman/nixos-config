{ config, pkgs, lib, ... }:

let
  # This cleanly evaluates to an absolute home path (e.g., /home/user/programs/models)
  modelDir = "/programs/models";
in
{
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

{ config, pkgs, inputs,  godotModule, ... }:
{
  home.file.".config/godot/editor_settings-4.6.tres" = {
    source = godotModule.configFile;
    force = true; 
  };
}

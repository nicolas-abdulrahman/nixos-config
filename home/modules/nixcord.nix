{ pkgs, lib, inputs, ... }:
{
  programs.nixcord = {
    enable = true;

    # Choose your client (enable only one of these two)
     discord.vencord.enable = true; # Standard Vencord
   # discord.equicord.enable = true; # Equicord (has more plugins)
    vesktop.enable = true;
  };

} 

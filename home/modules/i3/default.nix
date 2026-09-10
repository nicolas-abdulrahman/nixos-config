{pkgs, lib,...}: {

xsession.windowManager.i3 = {
  enable = true;
  config = {
    modifier = "Mod4";
    terminal = "${pkgs.st}/bin/st";
    gaps.inner = 10;
    fonts = {
      names = [ "monospace" ];
      size = 10.0;
    };
    bars = [{
      position = "bottom";
      statusCommand = "${pkgs.i3status}/bin/i3status";
    }];
    keybindings = lib.mkOptionDefault {
      "Mod4+t" = "exec ${pkgs.st}/bin/st";
      "Mod4+f" = "exec ${pkgs.firefox}/bin/firefox";
    };
  };
};
}

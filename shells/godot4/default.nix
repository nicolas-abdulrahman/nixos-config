{ pkgs, nvim }: # We accept nvim as an argument now

let
  godot-nvim = pkgs.writeScriptBin "godot-nvim" ''
    #!${pkgs.zsh}/bin/zsh
    SOCKET="/tmp/godot-nvim.pipe"
    FILE="$1"
    LINE="$2"
    if [ -S "$SOCKET" ]; then
        ${nvim}/bin/nvim --server "$SOCKET" --remote-send "<C-\><C-N>:e $FILE<CR>:$LINE<CR>"
    else
        ${pkgs.wezterm}/bin/wezterm start -- ${nvim}/bin/nvim --listen "$SOCKET" +"$LINE" "$FILE"
    fi
  '';

  godot-wrapped = pkgs.symlinkJoin {
    name = "godot4-wrapped";
    paths = [ pkgs.godot_4 ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/godot4 \
        --prefix PATH : ${pkgs.lib.makeBinPath [ godot-nvim pkgs.wezterm nvim pkgs.git pkgs.curl ]} \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" \
        --set SSL_CERT_DIR "${pkgs.cacert}/etc/ssl/certs/" \
        --add-flags "--editor-settings-path ${./.}"
    '';
  };
in
{
  configFile = ./editor_settings-4.6.tres;
  app = {
    type = "app";
    program = "${godot-wrapped}/bin/godot4";
  };
  shell = pkgs.mkShell {
    packages = [ godot-wrapped ];
  };
}

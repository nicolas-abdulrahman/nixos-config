{ pkgs, nvim, pkgs-unstable, nixgl }: # Added nixgl here so we can use it to link graphics

let
  godot-nvim = pkgs.writeScriptBin "godot-nvim" ''
    #!${pkgs.zsh}/bin/zsh
    SOCKET="/tmp/godot-nvim.pipe"
    FILE="$1"
    LINE="$2"
    PROJECT="$3"
    if [ -S "$SOCKET" ]; then
        ${nvim}/bin/nvim --server "$SOCKET" --remote-send "<C-\><C-N>:e $FILE<CR>:$LINE<CR>"
    else
        ${pkgs.wezterm}/bin/wezterm start \
        --class "godot-nvim" \
        --title "Godot Neovim" \
        --cwd "$PROJECT --${nvim}/bin/nvim --listen "$SOCKET" +"$LINE" "$FILE"
    fi
  '';

  godot-wrapped = let
    # Update this version string whenever you want to upgrade Godot!
    godot-version = "4.7-stable"; 
    short-version =  "4.7";   
    godot-official-bin = pkgs.fetchurl {
      url = "https://github.com/godotengine/godot/releases/download/${godot-version}/Godot_v${godot-version}_linux.x86_64.zip";
      # Nix will complain and give you the real hash on your first build attempt. 
      # Paste the real hash right here when it does!
      hash = "sha256-CxpsVMLGGcEuFp/pJB7dpLgQgLUZRRzsKYS/DSxstzw=";
    };
    runtimeLibs = with pkgs; [
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXext
      xorg.libXfixes
      wayland
      libxkbcommon
      fontconfig
    ];
  in
  pkgs.stdenv.mkDerivation {
    name = "godot4-wrapped";
    nativeBuildInputs = [ pkgs.makeWrapper pkgs.unzip ];
    
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      
      # 1. Unzip the official binary and put it into a hidden un-wrapped location
      unzip ${godot-official-bin} -d ./extracted_godot
      cp ./extracted_godot/Godot_v${godot-version}_linux.x86_64 $out/bin/.godot-unwrapped
      chmod +x $out/bin/.godot-unwrapped
      
      # 2. Wrap the hidden binary with all your paths and transient tmp configurations
      wrapProgram $out/bin/.godot-unwrapped \
        --prefix PATH : ${pkgs.lib.makeBinPath [ godot-nvim pkgs.wezterm nvim pkgs.git pkgs.curl ]} \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath runtimeLibs} \
        --set SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" \
        --set SSL_CERT_DIR "${pkgs.cacert}/etc/ssl/certs/" \
        --set XDG_CONFIG_HOME "/tmp/godot-runtime-config" \
        --set XDG_DATA_HOME "/tmp/godot-runtime-data" \
        --run '
          TARGET_DIR="/tmp/godot-runtime-config/godot"
          mkdir -p "$TARGET_DIR"
          rm -f "$TARGET_DIR/editor_settings-${short-version}.tres"
          cp "${./.}/editor_settings-${short-version}.tres" "$TARGET_DIR/editor_settings-${short-version}.tres" 2>/dev/null || true
          chmod +w "$TARGET_DIR/editor_settings-${short-version}.tres"
        '

      # 3. Create the main executable entrypoint that launches the wrapped binary via nixGL
      echo '#!/bin/sh' > $out/bin/godot4
      echo 'exec ${nixgl}/bin/nixGLIntel '$out/bin/.godot-unwrapped' "$@"' >> $out/bin/godot4
      chmod +x $out/bin/godot4
    '';
  };
in
{
  configFile = ./editor_settings-4.7.tres;
  app = {
    type = "app";
    program = "${godot-wrapped}/bin/godot4";
  };
  shell = pkgs.mkShell {
    packages = [ godot-wrapped ];
  };
}

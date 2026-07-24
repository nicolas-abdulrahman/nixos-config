{ pkgs,  ... }:

let

  # Define the script
  godot-nvim-script = pkgs.writeScriptBin "godot-nvim" ''
  #!${pkgs.bash}/bin/bash
  SOCKET="/tmp/godot_nvim.pipe"
  FILE="$1"
  LINE="$2"
  PROJECT="$3"
  
  NVIM_BIN="nvim"

  # Clean up dead socket if nvim crashed or closed
  if [ -S "$SOCKET" ] && ! "$NVIM_BIN" --server "$SOCKET" --remote-expr "1" &>/dev/null; then
    rm -f "$SOCKET"
  fi

  if [ -S "$SOCKET" ]; then
    # Socket exists and is responsive: open the file and jump to line
    "$NVIM_BIN" --server "$SOCKET" --remote-silent "$FILE"
    "$NVIM_BIN" --server "$SOCKET" --remote-send "<C-\><C-n>:$LINE<CR>"
  else
    # Launch WezTerm with Neovim listening on the socket
    ${pkgs.wezterm}/bin/wezterm start \
      --class "godot-nvim" \
      --cwd "$PROJECT" \
      -- $NVIM_BIN --listen "$SOCKET" +"$LINE" "$FILE" &

    # Wait for the socket to be created (up to 3 seconds)
    count=0
    while [ ! -S "$SOCKET" ] && [ $count -lt 30 ]; do
      sleep 0.1
      ((count++))
      echo done
    done
  fi
'';


  # Wrap godot to ensure it knows about our script
  godot-wrapped = pkgs.writeShellScriptBin "godot" ''
    export PATH="${godot-nvim-script}/bin:$PATH"
    exec ${pkgs.godotPackages_4_7.godot}/bin/godot "$@"
  '';
in
{

  app = {
    type = "app";
    program = "${godot-wrapped}/bin/godot";
  };
  shell = pkgs.mkShell {
    
    packages = [ 
      godot-wrapped 
      pkgs.uv
    ];
  };
}

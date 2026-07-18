{ pkgs,  ... }:

let

  # Define the script
  godot-nvim-script = pkgs.writeScriptBin "godot-nvim" ''
    #!${pkgs.zsh}/bin/zsh
    SOCKET="/tmp/godot_nvim.pipe"
    FILE="$1"
    LINE="$2"
    PROJECT="$3"
    
    # Use NVF/Neovim from path
    NVIM_BIN="nvim" 
    
    if [ -S "$SOCKET" ]; then
        $NVIM_BIN --server "$SOCKET" --remote-send "<C-\><C-N>:e $FILE<CR>:$LINE<CR>"
    else
        ${pkgs.wezterm}/bin/wezterm start \
        --class "godot-nvim" \
        --cwd "$PROJECT" \
        -- $NVIM_BIN --listen "$SOCKET" +"$LINE" "$FILE"
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
    packages = [ godot-wrapped ];
  };
}

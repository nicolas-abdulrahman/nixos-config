{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
in
pkgs.mkShell {
  name = nameNoExt;
  packages = with pkgs ;[ zsh zig zls ];
  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}

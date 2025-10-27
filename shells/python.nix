{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
in
pkgs.mkShell {
  name = nameNoExt;
  packages = [
    (pkgs.python3.withPackages (p: [
      p.pygame
      # pkgs.python314Packages.pillow
      p.pillow
      p.pip
      # Add more Python packages here as needed
    ]))
    pkgs.pyright
    pkgs.isort
    pkgs.black
  ];

  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}

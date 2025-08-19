{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
in
pkgs.mkShell {
  name = nameNoExt;
  packages = with pkgs; [ jdk21 ];
  buildInputs = with pkgs; [
    maven
    jdk21
    xorg.libX11
    openjdk21
    # customise the jdk which gradle uses by default
    (callPackage gradle-packages.gradle_8 {

      java = jdk21;

    })
  ];

  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}

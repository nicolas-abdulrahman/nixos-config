{ pkgs }:
let
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file;
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename;
in
pkgs.mkShell {
  name = nameNoExt;
  packages = with pkgs; [
    fish
    bun
    nodejs_26
    typescript
    pnpm
    typescript-language-server
    python3
  ];

  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"

    # Prevent recursive subshell loops if fish is already active
    if [ -z "$IN_FISH_SHELL" ]; then
      export IN_FISH_SHELL=1
      exec fish
    fi
  '';
}

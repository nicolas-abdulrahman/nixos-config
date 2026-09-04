{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
in
pkgs.mkShell {
  name = nameNoExt;
  hardeningDisable = [ "all" ];
  packages = with pkgs;[
    python3
    llvmPackages_16.clang-unwrapped
    gccgo13
    cmake
    gnumake
    bear

  ];
  nativeBuildInputs = [ ];
  buildInputs = with pkgs;[
    dbus
    libxkbcommon
    libGL
    ocamlPackages.ssl
    # WINIT_UNIX_BACKEND=wayland
    wayland
    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];

  CLANGD_PATH = pkgs.llvmPackages_16.clang-unwrapped;
  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}


{ pkgs }:
let
  # This gives something like: { file = "/path/to/shell.nix"; line = 1; column = 1; }
  pos = builtins.unsafeGetAttrPos "pkgs" { inherit pkgs; };
  filename = baseNameOf pos.file; # "shell.nix"
  nameNoExt = builtins.substring 0 (builtins.stringLength filename - 4) filename; # "shell"
in
pkgs.mkShell {
  name = nameNoExt;
  packages = with pkgs;[
    gdb
    pkgs.cargo
    pkgs.rustc # glibc
    pkgs.cargo-expand
    pkgs.rust-analyzer
  ];
  nativeBuildInputs = [ pkgs.pkg-config pkgs.cargo pkgs.ninja pkgs.protobuf ];
  buildInputs = with pkgs;[
    gtk4
    #   #openssl_3_1
    #   openssl_legacy
    #   dbus
    #   libxkbcommon
    #   python3
    #   libGL
    #   alsa-lib
    #    ocamlPackages.ssl
    #    WINIT_UNIX_BACKEND=wayland
    #   wayland
    #    WINIT_UNIX_BACKEND=x11
    #   xorg.libXcursor
    #   xorg.libXrandr
    #   xorg.libXi
    #   xorg.libX11
    #   qt6Packages.qxlsx
    #   graphene  
    #   protobuf
    #   sbclPackages.cl-gtk2-glib
    #   pkgs.lldb
    #   pkgs2.lldb   
    #   pkgs.pkg-config-unwrapped
    #   pkgs.libclang 
    #
  ];
  shellHook = ''
    echo "Welcome to Shell ${nameNoExt} (from ${filename})"
  '';
}


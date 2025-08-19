{
  description = "A very basic flake";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
     # nixpkgs2.url = github:nixos/nixpkgs;
  };

  outputs = { self, nixpkgs}: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
   # pkgs2 = import nixpkgs2 {inherit system;};
    in{
        devShells."${system}".default = pkgs.mkShell{
           packages = with pkgs; [
                    ];        
           buildInputs = with pkgs;[
                    wayland
                   libGLU
                   libglvnd
                   egl-wayland
                   libGL
                   eglexternalplatform
                   xdg-utils
                   openssl
                   chickenPackages_5.chickenEggs.opengl

            gtk4
            openssl_legacy
            dbus
            libxkbcommon
            python3
            alsa-lib
            # ocamlPackages.ssl
            # WINIT_UNIX_BACKEND=wayland
            wayland
            # WINIT_UNIX_BACKEND=x11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libX11
           # qt6Packages.qxlsx
            graphene  
            protobuf
            sbclPackages.cl-gtk2-glib
            pkgs.lldb
          #  pkgs2.lldb   
            #pkgs.pkg-config-unwrapped
            pkgs.libclang 
          ];
          NIX_LD_LIBRARY_PATH =  pkgs.lib.makeLibraryPath  [
                    pkgs.wayland
                   pkgs.libGLU
                   pkgs.libglvnd
                  pkgs.egl-wayland
                   pkgs.libGL
                   pkgs.eglexternalplatform
                   pkgs.xdg-utils
                     pkgs.stdenv.cc.cc
                    pkgs.openssl
                    pkgs.chickenPackages_5.chickenEggs.opengl
          ];
           # NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
        # GL_LIB = "${pkgs.libGL.lib}";
        # BANANA = "aaaa";
        };

      
     };
}


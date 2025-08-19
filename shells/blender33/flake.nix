
{
  description = "blender 3.3";
  inputs = {
      nixpkgs.url =https://github.com/NixOS/nixpkgs/archive/611bf8f183e6360c2a215fa70dfd659943a9857f.tar.gz;
  };
  outputs = { self, nixpkgs}: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    in{
        devShells."${system}".default = pkgs.mkShell{
           packages = with pkgs; [blender];        
              buildInputs = with pkgs;[
                    wayland
                   libGLU
                   libglvnd
                   egl-wayland
                   libGL
                 #  eglexternalplatform
          ];

        };
         
          packages.x86_64-linux.default = pkgs.mkShell{
              packages = [pkgs.blender];
          };

     };
}


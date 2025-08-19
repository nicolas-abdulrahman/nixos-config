{
  description = "Flake used for linux from scratch  12.1-rc";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
      pkgs2 = {
          # url = "https://github.com/NixOS/nixpkgs/archive/a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0.tar.gz";
          url = "github:nixos/nixpkgs/a5c9c6373aa35597cd5a17bc5c013ed0ca462cf0";
           flake = false;
      };
      pkgs3 ={ 
            url = "github:nixos/nixpkgs/473b58f20e491312a03c9c1578c89116e39a1d50";
            flake = false;
          }; 
      pkgs4 ={ 
            url = "github:nixos/nixpkgs/23befca742f67494f44dbe84070c9d56e7615c1b";
            flake = false;
          };

     # bison = pkgs.bison2;

  };

  outputs = { self, nixpkgs, ... }@inputs: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    pkgs2 = import inputs.pkgs2 { inherit system;};
    pkgs3 = import inputs.pkgs3 {inherit system;};
    pkgs4 = import inputs.pkgs4 {inherit system;};
    in{
        devShells."${system}".default = pkgs.mkShell{
            hardeningDisable = [ "all" ];
           packages = [
                pkgs.python3
                pkgs2.bison2
             #   pkgs3.gcc-unwrapped
            # pkgs.gcc6
                pkgs4.binutils
                pkgs.coreutils
                pkgs.gawk
              #  pkgs.grep
                pkgs.gzip
                pkgs.gnumake42
             #   inputs.pkgs.bison2
                
                 
               # pkgs.llvmPackages_13.clang-unwrapped
               pkgs.rocmPackages.llvm.clang
                pkgs.gccgo13
                pkgs.cmake 
                pkgs.gnumake
             #   bear

           ];        
           nativeBuildInputs =  [  ];
           buildInputs = with pkgs;[
        llvmPackages_13.clang-unwrapped
        libclang
               pkgs.rocmPackages.llvm.clang

            
            ];

 #           CLANGD_PATH = pkgs.llvmPackages_16.clang-unwrapped;

          #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
        };
       
     };
}


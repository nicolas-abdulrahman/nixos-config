{
  description = "A very basic flake";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
      R.url = "https://github.com/NixOS/nixpkgs/archive/f597e7e9fcf37d8ed14a12835ede0a7d362314bd.tar.gz";
  };

  outputs = { self, nixpkgs, ... } @inputs: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    Rpkgs = (import inputs.R {inherit system;});
    RStudio-with-my-packages = pkgs.rstudioWrapper.override{ 
            R = pkgs.R;
            # rstudio = pkgs.rstudio;
            packages = with pkgs.rPackages; [markdown markdownInput latexpdf rafalib UsingR Hmisc downloader ggplot2 dplyr xts ]; };

    in{
        devShells."${system}".default = pkgs.mkShell{
           packages = with pkgs;[
                rPackages.languageserver
                rPackages.languageserversetup
                RStudio-with-my-packages
                pkgs.R

            ];  
            RLSP = pkgs.rPackages.languageserver;
            RLSP2 = pkgs.rPackages.languageserver;

        };
       
     };
}


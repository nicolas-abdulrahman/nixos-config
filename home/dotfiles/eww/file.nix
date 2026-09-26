with import <nixpkgs> {};

let
  # Define the source file (assuming file.txt is in the same directory as this Nix expression)
  sourceFile1= ./eww.yuck;
  sourceFile2 = ./eww.scss;
in
stdenv.mkDerivation {
  name = "eww";
  
  # Copy the file into the Nix store
  phases = "installPhase";
  
  installPhase = ''
    mkdir -p $out
    cp ${sourceFile1} $out/eww.yuck
    cp ${sourceFile2} $out/eww.scss
  '';
}

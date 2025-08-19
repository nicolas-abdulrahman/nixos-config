{stdenv,
raylib,
...
}: stdenv.mkDerivation{
    pname = "myPkg";
    version = "v0.0.1";

    src = ./src;
    buildInputs =  [raylib];

    buildPhase = ''
        gcc -c main.c
        gcc main.o -o main
        '';
    installPhase= ''
        mkdir -p $out/bin
        mv main $out/bin/myPkg
        '';
}

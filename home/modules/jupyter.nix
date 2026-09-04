{ config, pkgs, inputs, lib, ... }:

{
  services.jupyter = lib.mkIf (config.full) {
    group = "jupyter";
    enable = true;
    password = "'123'";
    kernels = {
      r =
        let
          env = pkgs.rWrapper.override {
            packages = [ pkgs.rPackages.IRkernel ];
          };
          allRuntimePackages = [ ];
        in
        let
          wrappedEnv = pkgs.runCommand "wrapper-${env.name}"
            { nativeBuildInputs = [ pkgs.makeWrapper ]; }
            ''
              mkdir -p $out/bin
              for i in ${env}/bin/*; do
                filename=$(basename $i)
                ln -s ${env}/bin/$filename $out/bin/$filename
                wrapProgram $out/bin/$filename \
                  --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
              done
            '';
        in

        {
          displayName = "R for statics woaa";
          language = "R";
          argv = [
            "${wrappedEnv}/bin/R"
            "--slave"
            "-e"
            "IRkernel::main()"
            "--args"
            "{connection_file}"
          ];
          codemirrorMode = "R";
          logo64 = ./logo64.png;
        };
      # python={};

    };
  };
}

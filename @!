{ pkgs }:
pkgs.mkShell {    
        packages = with pkgs;
          [
            # myvscode
            vscode
          ];
        allowUnfree = true;
        buildInputs = with pkgs;[
        ];
        VSCODE = pkgs.vscode;
}


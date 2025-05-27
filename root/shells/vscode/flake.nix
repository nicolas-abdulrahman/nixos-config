{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    # nixpkgs2.url = github:nixos/nixpkgs;
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      myvscode = pkgs.vscode.fhs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          dracula-theme.theme-dracula
          vscodevim.vim
          yzhang.markdown-all-in-one
          editorconfig
          dbaeumer.vscode-eslint
          stylelint.vscode-stylelint
          zainchen.json

        ];
        # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #   {
        #     name = "remote-ssh-edit";
        #     publisher = "ms-vscode-remote";
        #     version = "0.47.2";
        #     sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        #   }
        # ];
      };
      # pkgs2 = import nixpkgs2 {inherit system;};
      vscode-wayland = pkgs.writeShellScriptBin "vscode-wayland" ''
        export VSCODE_PATH="${pkgs.vscode}"
        export OZONE_PLATFORM=wayland
        exec ${pkgs.vscode}/bin/code --ozone-platform=wayland "$@"
      '';
    in
    {
      apps."${system}".default =
        {
          type = "app";
          # program = "${pkgs.vscode}/bin/code";
          program = "${vscode-wayland}/bin/vscode-wayland";
        };
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs;
          [
            # myvscode
            vscode
          ];
        allowUnfree = true;
        buildInputs = with pkgs;[
        ];
        VSCODE = pkgs.vscode;
      };

    };
}


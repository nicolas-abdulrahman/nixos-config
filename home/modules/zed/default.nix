{ pkgs }:
pkgs.mkShell {    
    packages = with pkgs; [
    
        zed-editor

        # TypeScript / JS
        nodejs
        typescript
        typescript-language-server

        # useful
        git
        ripgrep
        fd
      ];
      shellHook = ''
  mkdir -p ~/.config/zed

  cat > ~/.config/zed/extensions.json <<EOF
{
  "extensions": [
    "codeium.codeium"
  ]
}
EOF
'';
}

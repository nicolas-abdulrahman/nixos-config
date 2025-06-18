{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.pkg-config
    pkgs.systemd # provides libudev
    pkgs.libinput # (optional, only if needed)
    pkgs.rustc
    pkgs.cargo
  ];

  # Optional: to allow access to /dev/input as non-root user
  shellHook = ''
    echo "✅ You are in a Rust dev shell with libudev!"
  '';
}


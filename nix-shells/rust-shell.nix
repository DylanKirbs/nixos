let
  stable = import <nixpkgs> { };
  unstable =
    import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
      { };
in

with stable;

mkShell {
  nativeBuildInputs = [
    pkg-config
    openssl
    gcc
    rustup
    man-pages
    man-pages-posix
  ];

  shellHook = ''
    export PATH=$PATH:$HOME/.cargo/bin
  '';
}

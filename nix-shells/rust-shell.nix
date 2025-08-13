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
    clang
    rustup
    man-pages
    man-pages-posix
    libgit2
    llvm
    rustc.llvmPackages.llvm
    grcov
  ];

  shellHook = ''
    export PATH=$PATH:$HOME/.cargo/bin
  '';
}

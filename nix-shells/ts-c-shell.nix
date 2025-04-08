let
  stable = import <nixpkgs> {};
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
in

with stable;

mkShell {
  nativeBuildInputs = [
    pkg-config
    openssl
    gcc
    nodejs_22
    gnumake
    graphviz
    #unstable.cargo
    unstable.rustup
    man-pages
    man-pages-posix
    valgrind
    clang-tools
  ];

  shellHook = ''
    export PATH=$PATH:$HOME/.cargo/bin
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/local/include
  '';
}

{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  nativeBuildInputs = [
    python312Full
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:$LD_LIBRARY_PATH
    export LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:$LIBRARY_PATH

    if [ ! -d ".venv" ]; then
      python3 -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip
    else
      source .venv/bin/activate
    fi
  '';
}
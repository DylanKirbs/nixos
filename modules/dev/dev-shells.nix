{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        py = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.python312 ];
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
        };

        jupyter = pkgs.mkShell {
          nativeBuildInputs = [
            (pkgs.python3.withPackages (
              ps: with ps; [
                numpy
                pandas
                matplotlib
                opencv4
                scikit-image
                jupyter
                ipython
                ipykernel
                python-lsp-server
                python-lsp-black
                pyls-isort
                pylsp-mypy
                python-lsp-ruff
                jupyterlab-lsp
                jupyterlab-git
              ]
            ))
            pkgs.nodejs
          ];

          shellHook = ''
            jupyter lab --ip=127.0.0.1 --port=8888
            exit
          '';
        };

        rust = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.openssl
            pkgs.gcc
            pkgs.clang
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.man-pages
            pkgs.man-pages-posix
            pkgs.libgit2
            pkgs.llvm
            pkgs.rustc.llvmPackages.llvm
            pkgs.grcov
          ];

          shellHook = ''
            export PATH=$PATH:$HOME/.cargo/bin
          '';
        };

        ts-c = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.openssl
            pkgs.gcc
            pkgs.nodejs_22
            pkgs.gnumake
            pkgs.graphviz
            pkgs.rustc
            pkgs.cargo
            pkgs.man-pages
            pkgs.man-pages-posix
            pkgs.valgrind
            pkgs.clang-tools
          ];

          shellHook = ''
            export PATH=$PATH:$HOME/.cargo/bin
            export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
            export C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/local/include
          '';
        };
      };
    };
}

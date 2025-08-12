{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
mkShell {
  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        # Core packages
        numpy
        pandas
        matplotlib
        opencv4
        scikit-image

        # Jupyter ecosystem
        jupyter
        ipython
        ipykernel

        # LSP and formatting
        python-lsp-server
        python-lsp-black
        pyls-isort
        pylsp-mypy
        python-lsp-ruff

        # JupyterLab extensions
        jupyterlab-lsp
        jupyterlab-git
        # jupyterlab-vim  # vim keybindings
      ]
    ))
    nodejs
  ];

  shellHook = ''
    jupyter lab --ip=127.0.0.1 --port=8888
    exit
  '';
}

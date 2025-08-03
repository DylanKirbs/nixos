{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

mkShell {
  nativeBuildInputs = [

    (python3.withPackages (
      ps: with ps; [

        # Packages
        numpy
        pandas
        matplotlib
        opencv4
        scikit-image

        # ipython
        jupyter
        ipython
        ipykernel

        # LSP
        python-lsp-server
        python-lsp-black
        lsprotocol
        pyls-isort
        jupyterlab-lsp
      ]
    ))
  ];

  shellHook = ''
    jupyter lab
    exit
  '';
}

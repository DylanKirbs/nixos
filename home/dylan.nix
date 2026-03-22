{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./common.nix
    ./nushell.nix
    ./gnome.nix
    ./sensible-vscode.nix
    ./lazy-nvim.nix
    ./kitty.nix
    ./warp-shell.nix
  ];

  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.packages =
    (with pkgs; [
      # Stable packages
      # Python
      (python312.withPackages (
        ps: with ps; [
          # Nice to haves
          numpy
          pandas
          matplotlib
          pygments
          tqdm
          scipy
          seaborn
          plotly

          pytest
          pyyaml
          openpyxl
          fastparquet

          tree-sitter
          tree-sitter-grammars.tree-sitter-c

          # LSP stuff
          python-lsp-server
          python-lsp-black
          pyls-isort
          pylsp-mypy
          python-lsp-ruff
        ]
      ))
      # Java
      jdk21
      maven

      # Rust/C
      cargo
      rustc
      rust-analyzer
      rustfmt
      gcc
      openssl
      pkg-config

      # Tex
      (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full pygmentex raleway;
      })
      jabref

      # Misc
      lutris
      reaper
      obsidian
      termpdfpy
      gh
      sshfs
      unzip
      termpdfpy
      ghostscript

      direnv
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
      tex-fmt
      gimp-with-plugins
      weylus
      hledger
    ]);

  home.sessionVariables = {
    PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.openssl ];
  };

  programs.git = {
    enable = true;
    userName = "Dylan Kirby";
    userEmail = "dylan.kirby.365@gmail.com";
  };
}

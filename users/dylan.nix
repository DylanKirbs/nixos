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
    ./modules/nushell.nix
    ./modules/gnome.nix
    ./modules/hyprland.nix
    ./modules/sensible-vscode.nix
    ./modules/lazy-nvim.nix
    ./modules/kitty.nix
    ./modules/warp-shell.nix
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
      texliveFull
      texlivePackages.pygmentex
      jabref

      # Misc
      lutris
      reaper
      obsidian
      termpdfpy
      gh
      sshfs
      unzip
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
      tex-fmt
      gimp-with-plugins
      weylus
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

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
      python312Full
      python312Packages.numpy
      python312Packages.pandas
      python312Packages.matplotlib
      python312Packages.pygments
      python312Packages.python-lsp-server
      python312Packages.python-lsp-black
      python312Packages.pyls-isort
      python312Packages.pylsp-mypy
      python312Packages.python-lsp-ruff

      # Java
      jdk21
      maven

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

  programs.git = {
    enable = true;
    userName = "Dylan Kirby";
    userEmail = "dylan.kirby.365@gmail.com";
  };
}

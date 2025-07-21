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
      
      # Python
      python312
      python312Packages.pip
      python312Packages.numpy
      python312Packages.pandas
      python312Packages.pygments
      python312Packages.jupyter-core

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

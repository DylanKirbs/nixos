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
  ];

  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.packages =
    (with pkgs; [
      # Stable packages
      python312
      python312Packages.pip
      python312Packages.numpy
      python312Packages.pandas
      jdk21
      maven
      helix
      texliveFull
      lutris
      jabref
      reaper
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

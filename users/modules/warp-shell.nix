{ config, lib, pkgs, ... }:

let
  scriptName = "warp-shell";
  scriptText = builtins.readFile ./warp-shell.sh;
in
{
  home.file."nix-shells" = {
    source = ../../nix-shells;
    target = "$HOME/nix-shells";
  };

  home.packages = [
    (pkgs.writeScriptBin scriptName scriptText)
  ];
}


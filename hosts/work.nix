{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./common.nix ];

  # Host-specific settings
  networking.hostName = "work";

  environment.systemPackages =
    (with pkgs; [
      # Stable packages
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
    ]);
}

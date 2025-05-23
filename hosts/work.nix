{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  user,
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

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "dylan" ];

}

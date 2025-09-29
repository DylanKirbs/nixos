{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  user,
  ...
}:
{
  imports = [
    ./display-managers/hyprland.nix
    ./common.nix
  ];

  # Host-specific settings
  networking.hostName = "home";

  services.openvpn.servers = {
    thmVPN = {
      config = ''config /home/dylan/openvpn/dylan.kirby.365.ovpn '';
    };
  };

  programs.steam = {
    package = pkgs.steam;
    enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      # Stable packages
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
    ]);
}

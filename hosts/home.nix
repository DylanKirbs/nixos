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
  networking.hostName = "home";

  services.openvpn.servers = {
    thmVPN = {
      config = ''config /home/dylan/openvpn/dylan.kirby.365.ovpn '';
    };
  };

  programs.steam = {
    package = pkgs.steam;
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  environment.systemPackages =
    (with pkgs; [
      # Stable packages
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
    ]);
}

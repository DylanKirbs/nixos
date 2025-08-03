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
      unzip
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
    ]);

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "dylan" ];

  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "dylan" ];
    };
  };
  services.fail2ban.enable = true;
  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };
}

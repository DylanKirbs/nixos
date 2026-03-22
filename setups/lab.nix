{ config, ... }:
let
  inherit (config.flake.modules) nixos home;
in
{
  configurations.nixos.lab.module = {
    imports = [
      {
        meta.username = "admin";
      }
      nixos.labBase
      nixos.homeManagerBase
      nixos.hostOptions
      nixos.gnome
      nixos.labHost
      {
        imports = [
          /etc/nixos/hardware-configuration.nix
        ];

        services.fstrim.enable = true;
      }
    ];

    home-manager.users.admin = {
      imports = [
        home.admin
      ];
    };
  };
}

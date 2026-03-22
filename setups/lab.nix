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
      nixos.common
      nixos.homeManagerBase
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

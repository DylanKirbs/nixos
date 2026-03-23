{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.lab.module = {
    imports = [
      inputs.agenix.nixosModules.default
      nixos.labBase
      nixos.homeManagerBase
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
        homeManager.admin
      ];
    };
  };
}

{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.work.module = {
    imports = [
      inputs.agenix.nixosModules.default
      nixos.common
      nixos.homeManagerBase
      nixos.gnome
      nixos.workHost
      {
        imports = [
          /etc/nixos/hardware-configuration.nix
        ];

        services.fstrim.enable = true;
      }
    ];

    home-manager.users.${config.meta.username} = {
      imports = [
        homeManager.dylan
      ];
    };
  };
}

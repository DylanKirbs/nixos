{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.work.module = {
    imports = [
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
        ../profiles/dylan.nix
      ];
    };
  };
}

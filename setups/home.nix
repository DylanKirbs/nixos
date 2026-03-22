{ config, ... }:
let
  inherit (config.flake.modules) nixos home;
in
{
  configurations.nixos.home.module = {
    imports = [
      nixos.hostOptions
      nixos.common
      nixos.homeManagerBase
      nixos.gnome
      nixos.homeHost
      {
        imports = [
          /etc/nixos/hardware-configuration.nix
        ];

        services.fstrim.enable = true;
      }
    ];

    home-manager.users.${config.meta.username} = {
      imports = [
        home.dylan
      ];
    };
  };
}

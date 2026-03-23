{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.home.module = {
    imports = [
      inputs.agenix.nixosModules.default
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

    home-manager.users.${config.meta.username} =
      { pkgs, ... }:
      {
        imports = [
          homeManager.dylan
        ];

        programs.gnome-shell.extensions = [
          { package = pkgs.gnomeExtensions.paperwm; }
        ];
      };
  };
}

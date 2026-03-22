{ lib, config, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name: definition:
    lib.nixosSystem {
      modules = [
        {
          networking.hostName = name;
        }
        definition.module
      ];
    }
  ) config.configurations.nixos;
}

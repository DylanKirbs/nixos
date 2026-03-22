{ inputs, config, ... }:
let
  allowedUnfreePackages = config.meta.allowedUnfreePackages;
in
{
  flake.modules.nixos.homeManagerBase =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfreePackages;
      };
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit pkgs-unstable;
        hostDisplayManager = config.hostDisplayManager;
      };
    };
}

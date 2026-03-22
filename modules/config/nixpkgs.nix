{ config, ... }:
let
  inherit (config.meta) allowedUnfreePackages;
  mkAllowUnfreePredicate = lib: pkg: builtins.elem (lib.getName pkg) allowedUnfreePackages;
in
{
  flake.modules.nixos._baseNixpkgs =
    { lib, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = mkAllowUnfreePredicate lib;
    };
}

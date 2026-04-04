{ config, inputs, ... }:
let
  inherit (config.meta) allowedUnfreePackages;
  mkAllowUnfreePredicate =
    lib: pkg: builtins.elem (lib.toLower (lib.getName pkg)) (map lib.toLower allowedUnfreePackages);
in
{
  flake.modules.nixos._baseNixpkgs =
    { lib, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = mkAllowUnfreePredicate lib;

      nixpkgs.overlays = [
        inputs.agenix.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfreePredicate = mkAllowUnfreePredicate lib;
          };
        })
      ];
    };
}

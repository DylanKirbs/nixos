{ lib, ... }:
{
  flake.modules.nixos.hostOptions = {
    options.hostDisplayManager = lib.mkOption {
      type = lib.types.enum [
        "gnome"
      ];
      default = "gnome";
      description = "Which DE/WM this host is configured for.";
    };
  };
}

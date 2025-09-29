{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hostDisplayManager = lib.mkOption {
    type = lib.types.enum [
      "gnome"
      "hyprland"
    ];
    default = "gnome";
    description = "Which DE/WM this host is configured for.";
  };
}

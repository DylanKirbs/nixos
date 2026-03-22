{ ... }:
{
  flake.modules.home.common = import ../../home/common.nix;
  flake.modules.home.dylan = import ../../home/dylan.nix;
  flake.modules.home.admin = import ../../home/admin.nix;
}

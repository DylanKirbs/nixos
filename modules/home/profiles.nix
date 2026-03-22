{ ... }:
{
  flake.modules.home.common = import ../../users/common.nix;
  flake.modules.home.dylan = import ../../users/dylan.nix;
  flake.modules.home.admin = import ../../users/admin.nix;
}

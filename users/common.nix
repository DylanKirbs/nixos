{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Common settings for all users

  home.stateVersion = "24.05"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  home.packages = [
    # pkgs.example
    # pkgs-unstable.example
  ];

  programs.git.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
  };

}

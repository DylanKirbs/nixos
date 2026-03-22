{ ... }:
{
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.stateVersion = "24.05"; # Please read the comment before changing.
      programs.home-manager.enable = true;

      home.packages = [
        # pkgs.example
        # pkgs-unstable.example
      ];

      programs.git.enable = true;

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 600;
        maxCacheTtl = 7200;
        pinentry.package = pkgs.pinentry-tty;
        extraConfig = ''
          allow-loopback-pinentry
        '';
      };
    };
}

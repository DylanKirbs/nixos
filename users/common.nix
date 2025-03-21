{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  user,
  ...
}:

{
  # Common settings for all users

  home.stateVersion = "24.05"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  home.packages = [
    # pkgs.example
    # pkgs-unstable.example
  ];

  programs.git.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
    pinentryPackage = pkgs.pinentry-tty;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}

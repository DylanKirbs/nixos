{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  allowed-unfree-pkgs,
  user,
  ...
}:
{
  # Shared settings for all hosts
  imports = [ /etc/nixos/hardware-configuration.nix ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit pkgs pkgs-unstable allowed-unfree-pkgs;
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  services.zerotierone.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs-unstable.nix-ld-rs;

  # Packages
  environment.systemPackages =
    (with pkgs; [
      # General
      vim
      git
      file
      wget
      btop
      inetutils
      tree
      ripgrep
      fd

      # Nix Dev
      nixfmt-rfc-style
      treefmt

      pkg-config
      openssl
      gnupg
      pinentry-tty

      ffmpeg-full
    ])
    ++ (with pkgs-unstable; [ firefox ]);

  # Other Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.xkb.layout = "za";

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}

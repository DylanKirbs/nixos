{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  allowed-unfree-pkgs,
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
    # users = {
    #   "dylan" = import ./home.nix;
    # };
  };

  # Packages
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-pkgs;
  environment.systemPackages =
    (with pkgs; [
      # Utils
      vim
      git
      file
      tree
      wget
      htop
      inetutils

      nixfmt-rfc-style
      treefmt2

      gnupg
      pinentry-tty

      ffmpeg-full

      # LibreOffice
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-ise
    ])
    ++ (with pkgs-unstable; [ firefox ]);

  # Other Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "za";
  services.printing.enable = true;

  virtualisation.docker.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}

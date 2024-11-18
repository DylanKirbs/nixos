{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  username,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kirby";
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

  nixpkgs.config.allowUnfree = true;
  users.users.dylan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  # home-manager = {
  #   useGlobalPkgs = true;
  #   backupFileExtension = "backup";
  #   extraSpecialArgs = {
  #     inherit inputs;
  #   };
  #   users = {
  #     "dylan" = import ./home.nix;
  #   };
  # };

  environment.systemPackages =
    (with pkgs; [
      # Stable packages
      firefox
      htop
      git
      vim
      tree
      nixfmt-rfc-style
      treefmt2
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-ise
    ])
    ++ (with pkgs-unstable; [
      # Unstable packages
    ]);

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # system.copySystemConfiguration = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}

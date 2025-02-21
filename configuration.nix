{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  allowed-unfree-pkgs,
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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-pkgs;

  users.users.dylan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  programs.steam = {
    package = pkgs.steam;
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Using NixOS module home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
    users = {
      "dylan" = import ./home.nix;
    };
  };

  environment.systemPackages =
    (with pkgs; [
      # Stable packages
      firefox
      htop
      git
      vim
      inetutils
      file
      wget
      python3
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

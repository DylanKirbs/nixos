{ config, ... }:
let
  inherit (config.meta) username;
in
{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos._baseNixpkgs
      ];

      users.users.${username} = {
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
      programs.nix-ld.package = pkgs.unstable.nix-ld;

      environment.systemPackages =
        (with pkgs; [
          vim
          git
          file
          wget
          btop
          inetutils
          tree
          ripgrep
          ripgrep-all
          fd
          fzf
          nixfmt-rfc-style
          treefmt
          pkg-config
          openssl
          gnupg
          pinentry-tty
          ffmpeg-full
          libreoffice-qt
          hunspell
          hunspellDicts.en_GB-ise
        ])
        ++ (with pkgs.unstable; [ firefox ]);

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

      system.stateVersion = "24.05";
    };
}

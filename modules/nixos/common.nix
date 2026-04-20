{ config, ... }:
let
  inherit (config.meta) username;
  baseNixpkgs = config.flake.modules.nixos._baseNixpkgs;
in
{
  flake.modules.nixos.common =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        baseNixpkgs
      ];

      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        shell = pkgs.bashInteractive;
      };

      services.zerotierone.enable = true;
      services.zerotierone.joinNetworks = [ ];

      age.secrets.zerotier-network-id.file = ../../secrets/zerotier-network-id.age;

      systemd.services.zerotier-join-network = {
        description = "Join ZeroTier network from agenix secret";
        wantedBy = [ "multi-user.target" ];
        after = [ "zerotierone.service" ];
        requires = [ "zerotierone.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
          if [ -r ${config.age.secrets.zerotier-network-id.path} ]; then
            network_id="$(tr -d '\n' < ${config.age.secrets.zerotier-network-id.path})"
            if [ -n "$network_id" ]; then
              ${pkgs.zerotierone}/bin/zerotier-cli join "$network_id"
            fi
          fi
        '';
      };

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
          agenix
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
      nix.settings.download-buffer-size = 524288000;

      system.stateVersion = "24.05";
    };
}

{ config, ... }:
let
  inherit (config.meta) username;
  baseNixpkgs = config.flake.modules.nixos._baseNixpkgs;
in
{
  flake.modules.nixos.homeHost =
    { pkgs, ... }:
    {
      programs.steam = {
        package = pkgs.steam;
        enable = true;
      };

      environment.systemPackages = with pkgs.unstable; [
        blender
      ];
    };

  flake.modules.nixos.workHost =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        unzip
      ];

      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ username ];

      services.openssh = {
        enable = true;
        ports = [ 5432 ];
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ username ];
        };
      };

      services.fail2ban.enable = true;
      services.endlessh = {
        enable = true;
        port = 22;
        openFirewall = true;
      };
    };

  flake.modules.nixos.labBase =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        baseNixpkgs
      ];

      users.users.admin = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        shell = pkgs.bashInteractive;
      };

      environment.systemPackages =
        (with pkgs; [
          bashInteractive
          btop
          file
          git
          inetutils
          tree
          wget
          agenix
        ])
        ++ (with pkgs.unstable; [ firefox ]);

      virtualisation.docker.enable = true;
      networking.networkmanager.enable = true;
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

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.openssh.enable = true;

      time.timeZone = "Africa/Johannesburg";
      i18n.defaultLocale = "en_GB.UTF-8";
      services.xserver.xkb.layout = "za";

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = "24.05";
    };

  flake.modules.nixos.labHost =
    {
      ...
    }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "admin" ];
        };
      };
    };
}

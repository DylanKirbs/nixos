{
  config,
  inputs,
  ...
}:
let
  inherit (config.meta) username allowedUnfreePackages;
in
{
  flake.modules.nixos.homeHost =
    {
      lib,
      pkgs,
      ...
    }:
    let
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfreePackages;
      };
    in
    {
      networking.hostName = "home";

      services.openvpn.servers = {
        thmVPN = {
          config = ''config /home/dylan/openvpn/dylan.kirby.365.ovpn '';
        };
      };

      programs.steam = {
        package = pkgs.steam;
        enable = true;
      };

      environment.systemPackages = with pkgs-unstable; [
        blender
      ];
    };

  flake.modules.nixos.workHost =
    {
      pkgs,
      ...
    }:
    {
      networking.hostName = "work";

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
}

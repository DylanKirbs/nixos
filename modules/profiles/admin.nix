{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.admin =
    { pkgs, ... }:
    {
      imports = [ hm.common ];

      home.username = "admin";
      home.homeDirectory = "/home/admin";

      home.packages = with pkgs; [
        btop
        git
        tmux
      ];
    };
}

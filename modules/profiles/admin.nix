{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.admin =
    { pkgs, ... }:
    {
      imports = [
        hm.common
        hm.kitty
        hm.lazyNvim
        hm.sensibleVscode
      ];

      home.username = "admin";
      home.homeDirectory = "/home/admin";

      home.packages = with pkgs; [
        btop
        fd
        ffmpeg-full
        fzf
        git
        nixfmt-rfc-style
        openssl
        ripgrep
      ];
    };
}

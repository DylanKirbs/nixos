{ config, lib, pkgs, ... }:

{
    programs.neovim = {
        enable = true;
        enableNushellIntegration = true;
    }

}
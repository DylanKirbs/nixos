{ config, lib, pkgs, ... }:

{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
       show_banner: false,
       completions: {
       case_sensitive: false
       quick: true
       partial: true
       algorithm: "fuzzy"
       external: {
           max_results: 100
           completer: $carapace_completer # check 'carapace_completer'
         }
       }
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      prepend /home/dylan/.apps |
      append /usr/bin/env
      )
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
}
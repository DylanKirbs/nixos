{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nushell = {
    enable = true;

    extraConfig = ''
      let carapace_completer = {|spans|
        try {
          carapace $spans.0 nushell $spans | from json
        } catch {
          []
        }
      }

      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false,
          quick: true,
          partial: true,
          algorithm: "fuzzy",
          external: {
            max_results: 100,
            completer: $carapace_completer
          }
        },
        ls: {
          clickable_links: true
        },
        rm: {
          always_trash: true
        },
        table: {
          mode: "rounded"
        },
        hooks: {
          pre_prompt: [{||
            # do something before prompt displays
          }]
        }
      }

      $env.PATH = ($env.PATH? | default [] |
        split row (char esep) |
        prepend ${lib.escapeShellArg "/home/dylan/.apps"} |
        append /usr/bin/env |
        uniq
      )
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
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

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
          carapace $spans.0 nushell $spans | from json
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


      # Zoxide configuration
      ${pkgs.zoxide}/bin/zoxide init nushell --cmd z | save -f ~/.zoxide.nu
      source ~/.zoxide.nu

      def --env zh [...rest] {
        if ($rest | is-empty) {
          # Interactive mode when no arguments provided - pipe result to cd
          let selected = (${pkgs.zoxide}/bin/zoxide query -i)
          if ($selected | is-empty) {
            return
          }
          z $selected
        } else {
          # Normal zoxide behavior with arguments
          z ...$rest
        }
      }

      alias cd = zh
      alias mv = mv -p
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

  programs.zoxide = {
    enable = true;
  };
}

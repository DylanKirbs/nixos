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

      # Carapace completer
      let carapace_completer = {|spans|
        # Handle alias expansion
        let expanded_alias = scope aliases
          | where name == $spans.0
          | if ($in | length) > 0 { 
              $in | first | get expansion 
            } else { 
              null 
            }

        let spans = if $expanded_alias != null {
          $spans
          | skip 1
          | prepend ($expanded_alias | split row ' ' | first)
        } else {
          $spans
        }

        carapace $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
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
      }

      $env.PATH = ($env.PATH? | default [] |
        split row (char esep) |
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
          # Normal zoxide behaviour with arguments
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

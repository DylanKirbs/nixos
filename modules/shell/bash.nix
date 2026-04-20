{ ... }:
{
  flake.modules.homeManager.bash =
    {
      ...
    }:
    {
      programs.bash = {
        enable = true;

        shellAliases = {
          mv = "mv -p";
        };

        initExtra = ''
          zh() {
            if [[ $# -eq 0 ]]; then
              local selected
              selected="$(zoxide query -i 2>/dev/null)"
              [[ -n "$selected" ]] && z "$selected"
            else
              z "$@"
            fi
          }

          alias cd='zh'
        '';
      };

      programs.carapace = {
        enable = true;
        enableBashIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
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
        enableBashIntegration = true;
      };
    };
}

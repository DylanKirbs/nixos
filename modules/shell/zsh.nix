{ ... }:
{
  flake.modules.homeManager.zsh =
    {
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          mv = "mv -p";
        };

        initContent = ''
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
        enableZshIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
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
        enableZshIntegration = true;
      };
    };
}
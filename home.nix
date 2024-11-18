{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.python3
    pkgs.jdk21
    # pkgs-unstable.example
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs = {

    git = {
      enable = true;
      userName = "Dylan Kirby";
      userEmail = "dylan.kirby.365@gmail.com";
    };

    vscode = {
      enable = true;
      package = pkgs-unstable.vscode;
      extensions = with pkgs-unstable.vscode-extensions; [
        streetsidesoftware.code-spell-checker
        #  microsoft.intellicode
        #  microsoft.extension-pack-for-java
        mhutchie.git-graph
        #  github.github-copilot
        #  yu-zhang.markdown-all-in-one
        #  yzane.markdown-pdf
        #  baptist-benoist.nix
        #  gruntfuggly.todo-tree
        #  jkiviluoto.trailing-whitespace
        #  vscode-icons-team.vscode-icons
        #  tomoki1207.vscode-pdf
        #  microsoft.docker
      ];
    };

    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions enable: true
         # set to lower can improve completion performance at the cost of omitting some options
             max_results: 100
             completer: $carapace_completer # check 'carapace_completer'
           }
         }
        }
        $env.PATH = ($env.PATH |
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
        )
      '';
      shellAliases = {
        vi = "hx";
        vim = "hx";
        nano = "hx";
      };
    };

    carapace.enable = true;
    carapace.enableNushellIntegration = true;

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

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

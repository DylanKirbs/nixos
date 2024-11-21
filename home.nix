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
    pkgs.python312
    pkgs.python312Packages.pip
    pkgs.jdk21
    pkgs.helix

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

      # temp fix: https://github.com/nix-community/home-manager/issues/5372
      mutableExtensionsDir = false;

      extensions = with pkgs-unstable.vscode-extensions; [

        # Utilities
        streetsidesoftware.code-spell-checker
        mhutchie.git-graph
        gruntfuggly.todo-tree
        ms-azuretools.vscode-docker
        bbenoist.nix
        formulahendry.code-runner

        # LSP + Completion
        visualstudioexptteam.vscodeintellicode
        github.copilot

        # Themes + Icons
        vscode-icons-team.vscode-icons

        # PDF + Markdown
        tomoki1207.pdf
        yzane.markdown-pdf
        yzhang.markdown-all-in-one

        # Python
        ms-python.python
        ms-python.vscode-pylance
        njpwerner.autodocstring

        # Java
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
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

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "vscode.desktop"
      ];
      had-bluetooth-devices-setup = true;
      remember-mount-password = false;
      welcome-dialog-last-shown-version = "42.4";
    };
    "org/gnome/shell/extensions/hidetopbar" = {
      enable-active-window = false;
      enable-intellihide = false;
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      toolkit-accessibility = true;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Console";
      command = "kgx";
      binding = "<Ctrl><Alt>t";
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

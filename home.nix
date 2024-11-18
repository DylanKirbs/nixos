{ config, pkgs, ... }:

{
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
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

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      streetsidesoftware.code-spell-checker
      microsoft.intellicode
      microsoft.extension-pack-for-java
      mhutchie.git-graph
      github.github-copilot
      yu-zhang.markdown-all-in-one
      yzane.markdown-pdf
      baptist-benoist.nix
      gruntfuggly.todo-tree
      jkiviluoto.trailing-whitespace
      vscode-icons-team.vscode-icons
      tomoki1207.vscode-pdf
      microsoft.docker
    ];
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

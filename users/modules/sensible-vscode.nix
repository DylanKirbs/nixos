{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;

    extensions = with pkgs-unstable.vscode-extensions; [
      # Utilities
      streetsidesoftware.code-spell-checker
      mhutchie.git-graph
      gruntfuggly.todo-tree
      ms-azuretools.vscode-docker
      bbenoist.nix
      formulahendry.code-runner
      arrterian.nix-env-selector
      usernamehw.errorlens

      # LSP + Completion
      visualstudioexptteam.vscodeintellicode
      github.copilot
      github.copilot-chat

      # Themes + Icons
      vscode-icons-team.vscode-icons

      # PDF + Markdown + Latex
      yzane.markdown-pdf
      yzhang.markdown-all-in-one
      james-yu.latex-workshop

      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.isort
      ms-python.black-formatter
      njpwerner.autodocstring

      # Java
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-maven

      # C
      ms-vscode.cpptools
      ms-vscode.cmake-tools

      # Haskell & Other Functional / Schema Langs
      haskell.haskell
      justusadam.language-haskell
    ];
  };
}

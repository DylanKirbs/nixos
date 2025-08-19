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

    profiles.default.extensions = with pkgs-unstable.vscode-extensions; [
      # Utilities
      streetsidesoftware.code-spell-checker
      mhutchie.git-graph
      gruntfuggly.todo-tree
      ms-azuretools.vscode-docker
      bbenoist.nix
      formulahendry.code-runner
      arrterian.nix-env-selector
      usernamehw.errorlens
      naumovs.color-highlight
      # fuzionix.devtool-plus

      # LSP + Completion
      visualstudioexptteam.vscodeintellicode
      github.copilot
      github.copilot-chat

      valentjn.vscode-ltex

      # Themes + Icons
      vscode-icons-team.vscode-icons

      # Web Dev
      bradlc.vscode-tailwindcss

      # PDF + Markdown + Latex
      yzane.markdown-pdf
      yzhang.markdown-all-in-one
      james-yu.latex-workshop

      tamasfe.even-better-toml

      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.isort
      ms-python.black-formatter
      njpwerner.autodocstring

      # Jupyter
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers

      # Java
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-maven

      # C
      ms-vscode.cpptools
      ms-vscode.cmake-tools

      # Haskell & Other Functional / Schema Langs
      # haskell.haskell
      # justusadam.language-haskell

      # Scala
      # scalameta.metals
      # scala-lang.scala

      # Rust
      rust-lang.rust-analyzer
    ];
  };
}

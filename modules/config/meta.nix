{ lib, ... }:
{
  options.meta = {
    username = lib.mkOption {
      type = lib.types.singleLineStr;
      default = "dylan";
      description = "Primary username used across shared modules.";
    };

    allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [
        "code"
        "vscode"
        "vscode-extension-github-copilot"
        "vscode-extension-github-copilot-chat"
        "vscode-extension-MS-python-vscode-pylance"
        "vscode-extension-mhutchie-git-graph"
        "vscode-extension-ms-vscode-cpptools"
        "vscode-extension-ms-vscode-remote-remote-ssh"
        "vscode-extension-github-codespaces"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "reaper"
        "obsidian"
        "zerotierone"
        "aspell-dict-en-science"
        "aspell-dict-en-computers"
      ];
      description = "Allowed unfree package names.";
    };
  };
}

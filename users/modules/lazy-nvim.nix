{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = lib.mkDefault true;

    package = pkgs-unstable.neovim-unwrapped;

    # Lua configuration for Lazy.nvim
    extraLuaConfig = builtins.readFile ./init-lazy-nvim.lua;
  };

  # Ensure some dependencies are available
  home.packages = with pkgs; [
    ripgrep
    fd
    nodejs
    zig
    clang-tools

    codespell
    cppcheck
    deadnix
  ];
}

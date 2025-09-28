return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Disable ensure_installed since we handle parsers via NixOS
      ensure_installed = {},
      -- Auto install is disabled in NixOS setup
      auto_install = false,
      -- Configure parsers that are provided by NixOS
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
      },
    },
  },
}

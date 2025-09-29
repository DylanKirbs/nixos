-- Disable Mason since we're using NixOS packages
return {
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = false,
  },
}

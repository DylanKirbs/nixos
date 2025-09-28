return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Configure snacks.nvim to work properly with NixOS
      picker = {
        -- Ensure sqlite3 is available for snacks.picker
        enabled = true,
      },
      image = {
        -- Disable image features that require external tools if not available
        -- or configure them to use the NixOS-provided tools
        backend = "ueberzug", -- or "kitty" depending on your terminal
      },
    },
  },
}

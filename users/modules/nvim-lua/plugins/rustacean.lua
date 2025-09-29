-- Configure rustaceanvim properly for NixOS
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Set up keybindings and other configuration
          local map = vim.keymap.set
          local opts = { buffer = bufnr }
          
          map("n", "<leader>ca", function()
            vim.cmd.RustLsp('codeAction')
          end, opts)
          map("n", "K", function()
            vim.cmd.RustLsp({ 'hover', 'actions' })
          end, opts)
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust if using Clippy
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                leptos_macro = {
                  "component",
                  "server",
                },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}

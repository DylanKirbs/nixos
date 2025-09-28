return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = false, -- Disable building
    config = function()
      -- Configure treesitter to use our pre-installed parsers
      local configs = require("nvim-treesitter.configs")
      
      -- Disable parser installation completely
      require("nvim-treesitter.install").prefer_git = false
      require("nvim-treesitter.install").compilers = {}
      
      -- Set the parser directory to our managed location
      vim.opt.runtimepath:prepend(vim.fn.stdpath("config") .. "/parser")
      
      configs.setup({
        ensure_installed = {},
        auto_install = false,
        sync_install = false,
        ignore_install = {},
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
      })
    end,
  },
}

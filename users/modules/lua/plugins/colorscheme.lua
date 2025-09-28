return {
  -- Configure LazyVim to load molokai
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
  
  -- Add molokai colorscheme
  {
    "UtkarshVerma/molokai.nvim",
    lazy = false,
    priority = 1000,
  },
}

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

    # Install Lazy.nvim automatically
    plugins = with pkgs-unstable.vimPlugins; [
      lazy-nvim # This installs Lazy, but we still need to configure it
    ];

    # Lua configuration for Lazy.nvim
    extraLuaConfig = ''
      -- Set up Lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", -- latest stable release
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      vim.opt.runtimepath:append("~/.local/share/nvim/site")


      -- Set up options before loading plugins
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Basic Neovim options
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = "a"
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = false
      vim.opt.breakindent = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true

      -- Load Lazy and setup plugins
      require("lazy").setup({
        -- Essential plugins
        { "nvim-lua/plenary.nvim" },  -- Dependency for many plugins

        -- UI Improvements
        { "UtkarshVerma/molokai.nvim" },  -- Colorscheme
        {
          "nvim-lualine/lualine.nvim",  -- Status line
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("lualine").setup({
              options = { theme = "molokai" }
            })
          end
        },

        -- File navigation
        {
          "nvim-telescope/telescope.nvim",  -- Fuzzy finder
          branch = "0.1.x",
          dependencies = { "nvim-lua/plenary.nvim" },
          config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
          end
        },

        -- LSP and Autocompletion
        {
          "neovim/nvim-lspconfig",  -- LSP configurations
          config = function()
            local lspconfig = require("lspconfig")
            local on_attach = function(client, bufnr)
              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end

            -- Setup language servers here
            lspconfig.pyright.setup({ on_attach = on_attach })
            lspconfig.rust_analyzer.setup({ on_attach = on_attach })
          end
        },

        {
          "pmizio/typescript-tools.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
          config = function()
            require("typescript-tools").setup({ on_attach = on_attach })
          end
        },

        {
          "hrsh7th/nvim-cmp",  -- Autocompletion
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
          },
          config = function()
            local cmp = require("cmp")
            cmp.setup({
              snippet = {
                expand = function(args)
                  require("luasnip").lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
              }, {
                { name = "buffer" },
              })
            })
          end
        },

        -- Syntax highlighting
        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          config = function()
            require("nvim-treesitter.configs").setup({
              ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "rust", "javascript", "typescript", "query" },
              highlight = { enable = true },
              indent = { enable = true },
            })
          end
        },

        -- Git integration
        {
          "lewis6991/gitsigns.nvim",
          config = function()
            require("gitsigns").setup()
          end
        },

        -- Quality of life improvements
        { "tpope/vim-commentary" },  -- Easy commenting
        { "tpope/vim-surround" },    -- Easy surrounding
        { "windwp/nvim-autopairs" }, -- Auto pair brackets
      })

      -- Set colorscheme after plugins are loaded
      vim.cmd("colorscheme molokai")
    '';
  };

  # Ensure some dependencies are available
  home.packages = with pkgs; [
    nerdfonts
    ripgrep
    fd
    nodejs
    gcc
    zig
    cl
  ];
}

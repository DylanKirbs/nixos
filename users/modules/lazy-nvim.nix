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
          vim.fn.system(
              {
                  "git",
                  "clone",
                  "--filter=blob:none",
                  "https://github.com/folke/lazy.nvim.git",
                  "--branch=stable", -- latest stable release
                  lazypath
              }
          )
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

      -- Add ruler 
      vim.opt.colorcolumn = "81,121"

      -- Highlight characters beyond 120 in red
      vim.api.nvim_set_hl(0, "OverLength", { fg = "#FF0000", bg = "none" })
      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "InsertLeave" }, {
        pattern = "*",
        callback = function()
          vim.fn.matchadd("OverLength", "\\%>120v.\\+", 120)
        end,
      })

      -- Command completion
      vim.opt.wildmenu = true
      vim.opt.wildmode = "list:longest"
      vim.opt.wildignore = {
          "*.docx",
          "*.jpg",
          "*.png",
          "*.gif",
          "*.pdf",
          "*.pyc",
          "*.exe",
          "*.flv",
          "*.img",
          "*.xlsx"
      }

      -- Backup and history settings
      vim.opt.history = 1000

      -- Persistent undo settings
      local undodir = vim.fn.stdpath("data") .. "/undodir"
      -- Create the directory if it doesn't exist
      if vim.fn.isdirectory(undodir) == 0 then
          vim.fn.mkdir(undodir, "p")
      end
      vim.opt.undodir = undodir
      vim.opt.undofile = true
      vim.opt.undoreload = 10000

      -- Load Lazy and setup plugins
      require("lazy").setup(
          {
              -- Essential plugins
              {"nvim-lua/plenary.nvim"}, -- Dependency for many plugins
              -- UI Improvements
              {"UtkarshVerma/molokai.nvim"}, -- Colorscheme
              {
                  "nvim-lualine/lualine.nvim", -- Status line
                  dependencies = {"nvim-tree/nvim-web-devicons"},
                  config = function()
                      require("lualine").setup(
                          {
                              options = {theme = "molokai"}
                          }
                      )
                  end
              },
              -- File navigation
              {
                  "nvim-telescope/telescope.nvim", -- Fuzzy finder
                  branch = "0.1.x",
                  dependencies = {"nvim-lua/plenary.nvim"},
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
                  "neovim/nvim-lspconfig", -- LSP configurations
                  config = function()
                      local lspconfig = require("lspconfig")
                      local on_attach = function(client, bufnr)
                          -- Enable completion triggered by <c-x><c-o>
                          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                          -- Enable hover documentation
                          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true})
                          -- Go to definition
                          vim.api.nvim_buf_set_keymap(
                              bufnr,
                              "n",
                              "gd",
                              "<cmd>lua vim.lsp.buf.definition()<CR>",
                              {noremap = true}
                          )
                          -- Show references
                          vim.api.nvim_buf_set_keymap(
                              bufnr,
                              "n",
                              "gr",
                              "<cmd>lua vim.lsp.buf.references()<CR>",
                              {noremap = true}
                          )
                          -- Show diagnostics on hover
                          vim.api.nvim_buf_set_keymap(
                              bufnr,
                              "n",
                              "<leader>e",
                              "<cmd>lua vim.diagnostic.open_float()<CR>",
                              {noremap = true}
                          )
                          -- Navigate between diagnostics
                          vim.api.nvim_buf_set_keymap(
                              bufnr,
                              "n",
                              "[d",
                              "<cmd>lua vim.diagnostic.goto_prev()<CR>",
                              {noremap = true}
                          )
                          vim.api.nvim_buf_set_keymap(
                              bufnr,
                              "n",
                              "]d",
                              "<cmd>lua vim.diagnostic.goto_next()<CR>",
                              {noremap = true}
                          )
                          -- Enable inlay hints (for parameter names and types)
                          if client.server_capabilities.inlayHintProvider then
                              vim.lsp.inlay_hint.enable(bufnr, true)
                          end
                      end

                      -- Setup language servers here
                      lspconfig.pyright.setup({on_attach = on_attach})
                      lspconfig.rust_analyzer.setup({on_attach = on_attach})

                      -- Setup for clangd
                      lspconfig.clangd.setup {
                          cmd = {
                              "clangd",
                              "--background-index",
                              "--suggest-missing-includes",
                              "--clang-tidy",
                              "--header-insertion=iwyu",
                              "--completion-style=detailed",
                              "--function-arg-placeholders",
                              "--fallback-style=llvm"
                          },
                          on_attach = on_attach,
                          flags = {
                              debounce_text_changes = 150
                          }
                      }
                  end
              },
              {
                "folke/trouble.nvim",
                opts = {}, -- for default options, refer to the configuration section for custom setup.
                cmd = "Trouble",
                keys = {
                  {
                    "<leader>xx",
                    "<cmd>Trouble diagnostics toggle<cr>",
                    desc = "Diagnostics (Trouble)",
                  },
                  {
                    "<leader>xX",
                    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                    desc = "Buffer Diagnostics (Trouble)",
                  },
                  {
                    "<leader>cs",
                    "<cmd>Trouble symbols toggle focus=false<cr>",
                    desc = "Symbols (Trouble)",
                  },
                  {
                    "<leader>cl",
                    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                    desc = "LSP Definitions / references / ... (Trouble)",
                  },
                  {
                    "<leader>xL",
                    "<cmd>Trouble loclist toggle<cr>",
                    desc = "Location List (Trouble)",
                  },
                  {
                    "<leader>xQ",
                    "<cmd>Trouble qflist toggle<cr>",
                    desc = "Quickfix List (Trouble)",
                  },
                },
              },
              {
                  "pmizio/typescript-tools.nvim", -- TS Tools
                  dependencies = {"nvim-lua/plenary.nvim"},
                  config = function()
                      require("typescript-tools").setup({on_attach = on_attach})
                  end
              },
              {
                  "hrsh7th/nvim-cmp", -- Autocompletion
                  dependencies = {
                      "hrsh7th/cmp-nvim-lsp",
                      "hrsh7th/cmp-buffer",
                      "hrsh7th/cmp-path",
                      "hrsh7th/cmp-cmdline",
                      "L3MON4D3/LuaSnip",
                      "saadparwaiz1/cmp_luasnip"
                  },
                  config = function()
                      local cmp = require("cmp")
                      cmp.setup(
                          {
                              snippet = {
                                  expand = function(args)
                                      require("luasnip").lsp_expand(args.body)
                                  end
                              },
                              mapping = cmp.mapping.preset.insert(
                                  {
                                      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                      ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                      ["<C-Space>"] = cmp.mapping.complete(),
                                      ["<C-e>"] = cmp.mapping.abort(),
                                      ["<CR>"] = cmp.mapping.confirm({select = true})
                                  }
                              ),
                              sources = cmp.config.sources(
                                  {
                                      {name = "nvim_lsp"},
                                      {name = "luasnip"}
                                  },
                                  {
                                      {name = "buffer"}
                                  }
                              )
                          }
                      )
                  end
              },
              {
                  "nvim-treesitter/nvim-treesitter", -- Syntax Highlighting
                  build = ":TSUpdate",
                  config = function()
                      require("nvim-treesitter.configs").setup(
                          {
                              ensure_installed = {
                                  "c",
                                  "lua",
                                  "vim",
                                  "vimdoc",
                                  "python",
                                  "rust",
                                  "javascript",
                                  "typescript",
                                  "query"
                              },
                              highlight = {enable = true},
                              indent = {enable = true}
                          }
                      )
                  end
              },
              {
                  "nvim-treesitter/nvim-treesitter-context", -- Treesitter context for macros and functions
                  config = function()
                      require("treesitter-context").setup(
                          {
                              enable = true,
                              max_lines = 0,
                              trim_scope = "outer"
                          }
                      )
                  end
              },
              {
                  "simrat39/symbols-outline.nvim", -- Enhanced symbols outline
                  config = function()
                      require("symbols-outline").setup()
                      vim.keymap.set("n", "<leader>so", "<cmd>SymbolsOutline<CR>")
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
              {"tpope/vim-commentary"}, -- Easy commenting
              {"tpope/vim-surround"}, -- Easy surrounding
              {"windwp/nvim-autopairs"}, -- Auto pair brackets
              -- LSP
              {"nvim-lua/lsp-status.nvim"}, -- LSP UI
              {
                  "glepnir/lspsaga.nvim",
                  config = function()
                      require("lspsaga").setup(
                          {
                              lightbulb = {
                                  enable = true,
                                  enable_in_insert = true,
                                  sign = true
                              },
                              code_action = {
                                  show_server_name = true
                              },
                              finder = {
                                  keys = {
                                      edit = {"o", "<CR>"}
                                  }
                              }
                          }
                      )
                      -- Key mappings for LSP saga
                      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
                      vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
                      vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>")
                      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
                  end
              }
          },

          {
              "nvimtools/none-ls.nvim", -- null-ls fork that's maintained
                dependencies = {"nvim-lua/plenary.nvim"},
                config = function()
                    local null_ls = require("null-ls")
                    null_ls.setup({
                        sources = {
                            -- Spelling / Meta
                            null_ls.builtins.diagnostics.codespell,
                            null_ls.builtins.diagnostics.todo_comments,
                            -- C/C++
                            null_ls.builtins.diagnostics.cppcheck,
                            null_ls.builtins.formatting.clang_format,
                            -- Nix
                            null_ls.builtins.diagnostics.deadnix,
                        }
                    })
                end
            }

      -- End of plugins
      )

      -- Set colorscheme after plugins are loaded
      vim.cmd("colorscheme molokai")
    '';
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

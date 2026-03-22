-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Spell checking configuration
vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }
vim.opt.spelloptions = "camel"

-- Clipboard configuration for NixOS
vim.opt.clipboard = "unnamedplus"

-- Ensure proper clipboard provider
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "wsl clipboard",
    copy = { ["+"] = { "clip.exe" }, ["*"] = { "clip.exe" } },
    paste = { ["+"] = { "powershell.exe", "-c", "Get-Clipboard" }, ["*"] = { "powershell.exe", "-c", "Get-Clipboard" } },
    cache_enabled = true,
  }
elseif vim.fn.has("unix") == 1 then
  -- Use wl-clipboard for Wayland or xclip for X11
  if os.getenv("WAYLAND_DISPLAY") then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = { ["+"] = { "wl-copy" }, ["*"] = { "wl-copy", "--primary" } },
      paste = { ["+"] = { "wl-paste", "--no-newline" }, ["*"] = { "wl-paste", "--no-newline", "--primary" } },
      cache_enabled = true,
    }
  else
    vim.g.clipboard = {
      name = "xclip",
      copy = { ["+"] = { "xclip", "-selection", "clipboard" }, ["*"] = { "xclip", "-selection", "primary" } },
      paste = { ["+"] = { "xclip", "-selection", "clipboard", "-o" }, ["*"] = { "xclip", "-selection", "primary", "-o" } },
      cache_enabled = true,
    }
  end
end

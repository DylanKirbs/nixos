-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if vim.env.TERM == "xterm-kitty" then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			io.stdout:write("\027[>1u")
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			io.stdout:write("\027[<1u")
		end,
	})
end

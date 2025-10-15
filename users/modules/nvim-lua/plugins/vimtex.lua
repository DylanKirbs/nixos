return {
	"lervag/vimtex",
	lazy = false, -- load immediately for .tex files
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "build",
		}
	end,
}
